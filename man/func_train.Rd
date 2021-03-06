% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/ops-function.R
\name{func_train}
\alias{func_train}
\title{Train Function Model}
\usage{
func_train(func, minibatch_source, minibatch_size = 32, streams = NULL,
  model_inputs_to_streams = NULL, parameter_learners = c(),
  callbacks = c(), progress_frequency = NULL, max_epochs = NULL,
  epoch_size = NULL, max_samples = NULL)
}
\arguments{
\item{func}{- The CNTK `Function` instance on which to apply the operation}

\item{minibatch_source}{(MinibatchSource or list of matrices) –
data source used for training. For large data, use a MinibatchSource. For
small data, pass a list of matrices. The number of streams/arrays
must match the number of arguments of self.}

\item{minibatch_size}{(int or minibatch_size_schedule, defaults to 32) –
minibatch size (or schedule) for training}

\item{streams}{(list) – (only if minibatch_source is a data reader)
the streams of the minibatch_source in argument order. Not to be given if
minibatch_source is specified as numpy/scipy arrays rather than a data
reader.}

\item{model_inputs_to_streams}{(dict) – alternative to streams, specifying
the mapping as a map from input variables to streams}

\item{parameter_learners}{(list) – list of learners}

\item{callbacks}{- list of callback objects, which can be of type
ProgressWriter (for logging), CheckpointConfig (for #' check-pointing),
TestConfig (for automatic final evaluation on a test set), #' and
CrossValidationConfig (for cross-validation based training control).}

\item{progress_frequency}{(int) – frequency in samples for aggregated
progress printing. Defaults to epoch_size if given, or None otherwise}

\item{max_epochs}{(int, defaults to 1) – maximum number of samples used for
training; requires epoch_size}

\item{epoch_size}{(int) – in CNTK, epoch size means the number of samples
between outputting summary information and/or checkpointing. This must be
specified unless the user directly passes numpy/scipy arrays for the
minibatch_source.}

\item{max_samples}{(int) – maximum number of samples used for training;
mutually exclusive with max_epochs}
}
\description{
Trains a model, given by its criterion function, using the specified
training parameters and configs. Different aspects of training such as data
sources, checkpointing, cross validation, progress printing can be
configured using the corresponding config classes.
}
\details{
The input data can be specified as a data reader (MinibatchSource) for large
corpora; or directly as numpy/scipy arrays if the data is so small that it
is feasible to keep it all in RAM.

Data is processed in minibatches. The minibatch size defaults to 32, which
is a choice that commonly works well. However, for maximum efficiency, we
recommend to experiment with minibatch sizes and choose the largest that
converges well and does not exceed the GPU RAM. This is particularly
important for distributed training, where often, the minibatch size can be
increased throughout the training, which reduces data bandwidth and thus
speeds up parallel training.

If input data is given through a data reader (as opposed to directly as a
numpy/scipy array), the user must also specify the epoch size. This is
because data readers are used for large corpora, and the traditional
definition of epoch size as number of samples in the corpus is not very
relevant. Instead, CNTK really means the number of samples between summary
actions, such as printing training progress, adjusting the learning rate,
and/or checkpointing the model.

The function returns an object that contains these members: epoch_summaries
is a list that contains the progression of epoch loss (.loss) and metric
(.metric) values and the corresponding number of labels (.samples) that they
were averaged over. This is the same value that a progress printer would
print as epoch summaries. updates is a similar list with the more
fine-grained minibatch updates. If a TestConfig was specified, then
test_summary is the metric and sample count on the specified test set for
the final model.

A number of callback mechanisms can optionally be specified as a list as
callbacks. CNTK has a fixed set of callback types, and only those types are
allowed in the callbacks list: An object of type ProgressWriter from
cntk.logging is used for progress logging; a CheckpointConfig configures the
checkpointing mechanism, which keeps copies of models at regular intervals
and allows to seamlessly restart from a last checkpoint; a TestConfig allows
to specify a test set that is evaluated at the end of the training; and a
CrossValidationConfig specifies a user callback that can be used to adjust
learning hyper-parameters or to denote to stop training, optionally based on
a separate cross-validation data set.
}
