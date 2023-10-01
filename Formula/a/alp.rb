class Alp < Formula
  desc "Access Log Profiler"
  homepage "https://github.com/tkuchiki/alp"
  url "https://ghproxy.com/https://github.com/tkuchiki/alp/archive/v1.0.19.tar.gz"
  sha256 "a336776379a9d46222ac7d8309714772b848d95111a482b0a1526dde5af81dec"
  license "MIT"
  head "https://github.com/tkuchiki/alp.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ed66be85ad016bafa66943b7d7f25cbb3933c5a1ad6eb6dd26ac69efb06e1c3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c040d7d97cfb24ad9e22d2cd4965469f8831d217e4aea8f7b0a6e3c026167ae"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1db02e17f990c3eb1eab0462774a1d7cc78e0b66c67c1419e7a4938dca39e7d"
    sha256 cellar: :any_skip_relocation, sonoma:         "f57196f1b86571f0bed2dea0ed5cfc59e46ca3494e00800b7c802ff1200a207d"
    sha256 cellar: :any_skip_relocation, ventura:        "93b092fdbd4021b1defe1ac50deab95b11dd6f038c5d9e389112e5cb3be3ba70"
    sha256 cellar: :any_skip_relocation, monterey:       "39c77b8613aea21d5617c413cab241f6ad927cb9ae1230804a0ad47331ba6e41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ad10009596770ba551cbd14a8fb41f0bd35fb54b0a1bd22c254edc1e7e1d163e"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/alp"

    generate_completions_from_executable(bin/"alp", "completion")
  end

  test do
    (testpath/"json_access.log").write <<~EOS
      {"time":"2015-09-06T05:58:05+09:00","method":"POST","uri":"/foo/bar?token=xxx&uuid=1234","status":200,"body_bytes":12,"response_time":0.057}
      {"time":"2015-09-06T05:58:41+09:00","method":"POST","uri":"/foo/bar?token=yyy","status":200,"body_bytes":34,"response_time":0.100}
      {"time":"2015-09-06T06:00:42+09:00","method":"GET","uri":"/foo/bar?token=zzz","status":200,"body_bytes":56,"response_time":0.123}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"/foo/bar","status":400,"body_bytes":15,"response_time":"-"}
      {"time":"2015-09-06T05:58:44+09:00","method":"POST","uri":"/foo/bar?token=yyy","status":200,"body_bytes":34,"response_time":0.234}
      {"time":"2015-09-06T05:58:44+09:00","method":"POST","uri":"/hoge/piyo?id=yyy","status":200,"body_bytes":34,"response_time":0.234}
      {"time":"2015-09-06T05:58:05+09:00","method":"POST","uri":"/foo/bar?token=xxx&uuid=1234","status":200,"body_bytes":12,"response_time":0.057}
      {"time":"2015-09-06T05:58:41+09:00","method":"POST","uri":"/foo/bar?token=yyy","status":200,"body_bytes":34,"response_time":0.100}
      {"time":"2015-09-06T06:00:42+09:00","method":"GET","uri":"/foo/bar?token=zzz","status":200,"body_bytes":56,"response_time":0.123}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"/foo/bar","status":400,"body_bytes":15,"response_time":"-"}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"/diary/entry/1234","status":200,"body_bytes":15,"response_time":0.135}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"/diary/entry/5678","status":200,"body_bytes":30,"response_time":0.432}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"/foo/bar/5xx","status":504,"body_bytes":15,"response_time":60.000}
      {"time":"2015-09-06T06:00:43+09:00","method":"GET","uri":"/req","status":200,"body_bytes":15,"response_time":"-", "request_time":0.321}
    EOS
    system "#{bin}/alp", "json", "--file=#{testpath}/json_access.log", "--dump=#{testpath}/dump.yml"
    assert_predicate testpath/"dump.yml", :exist?
  end
end