python main.py --model_name=idr_pretrained_x2 --scale=2 --is_train=True --learning_rate=1e-4 --decay_learning_rate=False --epochs=100000 --batch_size=64 --pretrain=False
python main.py --model_name=idr_x2 --scale=2 --is_train=True --learning_rate=1e-4 --decay_learning_rate=True --epochs=600000 --batch_size=64 --pretrain=True --pretrained_model_name=idr_pretrained_x2

: python main.py --model_name=selfex_2 --scale=2 --is_train=False