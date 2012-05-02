require 'unittest.rb'

test 'Query domain name in delegated zone (1)' do
  query 'x.sub1.example.com' do
    assert_status 'NOERROR'
    assert_flags 'qr', '!aa'
    assert_noanswer
    assert_authority 'ns1.sub1.example.com', 'ns2.sub1.example.com'
    assert_noadditional
  end
end

test 'Query domain name in delegated zone (2)' do
  query 'x.sub2.example.com' do
    assert_status 'NOERROR'
    assert_flags 'qr', '!aa'
    assert_noanswer
    assert_authority 'ns1.sub2.example.com', 'ns2.sub2.example.com'
    assert_additional '192.0.2.11', '2001:db8::2:11'
    assert_additional '192.0.2.12', '2001:db8::2:12'
  end
end

test 'Query referral itsself' do
  query 'NS sub2.example.com' do
    assert_status 'NOERROR'
    assert_flags 'qr', '!aa'
    assert_noanswer
    assert_authority 'ns1.sub2.example.com', 'ns2.sub2.example.com'
    assert_additional '192.0.2.11', '2001:db8::2:11'
    assert_additional '192.0.2.12', '2001:db8::2:12'
  end
end

test 'Query CNAME to referral' do
  query 'NS b.example.com' do
    assert_status 'NOERROR'
    assert_flags 'qr', 'aa'
    assert_answer 'sub2.example.com', 'CNAME'
    assert_authority 'ns1.sub2.example.com', 'ns2.sub2.example.com'
    assert_additional '192.0.2.11', '2001:db8::2:11'
    assert_additional '192.0.2.12', '2001:db8::2:12'
  end
end

test 'Query CNAME to zone NS' do
  query 'NS c.example.com' do
    assert_status 'NOERROR'
    assert_flags 'qr', 'aa'
    assert_answer 'example.com', 'CNAME'
    assert_answer 'ns1.example.com', 'NS'
    assert_answer 'ns2.example.com', 'NS'
    assert_noauthority
    assert_additional '192.0.2.11', '2001:db8::2:11'
    assert_additional '192.0.2.12', '2001:db8::2:12'
  end
end
