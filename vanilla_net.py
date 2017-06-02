
# import required libraries
import numpy as np
import scipy.io as io
from keras.utils import np_utils
from keras.datasets import mnist
from keras.models import Sequential
from keras.layers.core import Dense, Dropout

# initialize model
model = Sequential()
# add first hidden layer (784 layer assumed)
model.add(Dense(500, input_shape=(784,), activation='relu'))
model.add(Dropout(0.2))
# add second hidden layer
model.add(Dense(300, activation='relu'))
model.add(Dropout(0.2))
model.add(Dense(10, activation='softmax'))

# compile model
model.compile(loss='mean_squared_error', optimizer='adam', metrics=['accuracy'])

#import data from MNIST Database
(X_train, y_train), (X_test, y_test) = mnist.load_data()

# massage data
X_train = X_train.reshape(60000, 784)
X_test = X_test.reshape(10000, 784)
X_train = (X_train.astype('float32'))/255
X_test = (X_test.astype('float32'))/255

Y_train = np_utils.to_categorical(y_train, 10)
Y_test = np_utils.to_categorical(y_test, 10)

# train model
model.fit(X_train, Y_train, batch_size=128, epochs=4, verbose=1, validation_data=(X_test, Y_test))

# evaluate model
score = model.evaluate(X_test, Y_test, verbose=2)
print('Test score:', score[0])
print('Test accuracy:', score[1])

# extract model and save weights to a .mat file
weights = model.get_weights()

# write individual layers to a dictionary
weight_dict = {}
# initiate counters
layer_count = 0
bias_count = 0
for i, layer in enumerate(weights):
    # sort into odd and even indices
    if i%2 == 0:
        layer_count += 1
        weight_dict['weights_{0}'.format(layer_count)] = weights[i]
    else:
        bias_count += 1
        weight_dict['biases_{0}'.format(bias_count)] = weights[i]

# save weights and biases into .mat file
io.savemat('./weights.mat',weight_dict)
