function dataOut(data, names, date)
% 함수 기능: Matlab의 xlswrite 함수를 사용하여 14201 x 42 형태의 데이터와 1 x 42 형태의 이름을 엑셀 파일로 저장하는 함수
% 입력인자: data - 14201 x 42 형태의 행렬
%           names - 1 x 42 형태의 문자열 행렬
%           date - 파일 제목으로 사용될 문자열 (예: '2022-02-24')
% 출력인자: 없음

filename = [date, '.xlsx'];
data_with_names = [names; num2cell(data)];
xlswrite(filename, data_with_names);

end