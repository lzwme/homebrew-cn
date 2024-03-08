class Alp < Formula
  desc "Access Log Profiler"
  homepage "https:github.comtkuchikialp"
  url "https:github.comtkuchikialparchiverefstagsv1.0.21.tar.gz"
  sha256 "cb46bbf1c8a1feace9ea23447509a7b7fad8960e9e73948fcfdf012436c64390"
  license "MIT"
  head "https:github.comtkuchikialp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e947c50b3cfeb2580521b828119cf5e6e1590b3596415f93a5525fc6157c0765"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c8f75372afd0b575d95b8f5d6f1f0cdda3dc9d7748974286aaa2823f3d98bc39"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "17f070fc807d0190a175d61ac599920e0af0b791d52f7831c28d6714263d0dbe"
    sha256 cellar: :any_skip_relocation, sonoma:         "37d8da350c6ca544b05f4cf14e4a60037865958c73d6023e75f2f61000b3f572"
    sha256 cellar: :any_skip_relocation, ventura:        "ba54691789ec295053d9a208d3ecae57fbdd176692ddee4cbbcdecbea570d0a8"
    sha256 cellar: :any_skip_relocation, monterey:       "508bdbaf309ca746ed76d0fbc3028a5f3f8b1bacafa65ffd2a46282f1afe147a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e1770f74c2881e2147f43cf2a182b4a5c60cd5c324120127d70c938459cd735"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags:), ".cmdalp"

    generate_completions_from_executable(bin"alp", "completion")
  end

  test do
    (testpath"json_access.log").write <<~EOS
      {"time":"2015-09-06T05:58:05+09:00","method":"POST","uri":"foobar?token=xxx&uuid=1234","status":200,"body_bytes":12,"response_time":0.057}
      {"time":"2015-09-06T05:58:41+09:00","method":"POST","uri":"foobar?token=yyy","status":200,"body_bytes":34,"response_time":0.100}
      {"time":"2015-09-06T06:00:42+09:00","method":"GET","uri":"foobar?token=zzz","status":200,"body_bytes":56,"response_time":0.123}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"foobar","status":400,"body_bytes":15,"response_time":"-"}
      {"time":"2015-09-06T05:58:44+09:00","method":"POST","uri":"foobar?token=yyy","status":200,"body_bytes":34,"response_time":0.234}
      {"time":"2015-09-06T05:58:44+09:00","method":"POST","uri":"hogepiyo?id=yyy","status":200,"body_bytes":34,"response_time":0.234}
      {"time":"2015-09-06T05:58:05+09:00","method":"POST","uri":"foobar?token=xxx&uuid=1234","status":200,"body_bytes":12,"response_time":0.057}
      {"time":"2015-09-06T05:58:41+09:00","method":"POST","uri":"foobar?token=yyy","status":200,"body_bytes":34,"response_time":0.100}
      {"time":"2015-09-06T06:00:42+09:00","method":"GET","uri":"foobar?token=zzz","status":200,"body_bytes":56,"response_time":0.123}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"foobar","status":400,"body_bytes":15,"response_time":"-"}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"diaryentry1234","status":200,"body_bytes":15,"response_time":0.135}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"diaryentry5678","status":200,"body_bytes":30,"response_time":0.432}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"foobar5xx","status":504,"body_bytes":15,"response_time":60.000}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"req","status":200,"body_bytes":15,"response_time":"-", "request_time":0.321}
    EOS
    system "#{bin}alp", "json", "--file=#{testpath}json_access.log", "--dump=#{testpath}dump.yml"
    assert_predicate testpath"dump.yml", :exist?
  end
end