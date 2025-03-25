class Pinact < Formula
  desc "Pins GitHub Actions to full hashes and versions"
  homepage "https:github.comsuzuki-shunsukepinact"
  url "https:github.comsuzuki-shunsukepinactarchiverefstagsv2.1.0.tar.gz"
  sha256 "1fcd2a45767aedb5cff4de72cbb8acacee0d841641d0dd8c2b787c3fb47b8d30"
  license "MIT"
  head "https:github.comsuzuki-shunsukepinact.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba5eb0e4e270bfc01db5b82f09b0cd1b6c9ae463e31c2e15793c9fe58e3bcd5c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ba5eb0e4e270bfc01db5b82f09b0cd1b6c9ae463e31c2e15793c9fe58e3bcd5c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "ba5eb0e4e270bfc01db5b82f09b0cd1b6c9ae463e31c2e15793c9fe58e3bcd5c"
    sha256 cellar: :any_skip_relocation, sonoma:        "6f1bb20c3034d18f099a74036abe1ea791f2b746548fe28c6835e78a0fb05689"
    sha256 cellar: :any_skip_relocation, ventura:       "6f1bb20c3034d18f099a74036abe1ea791f2b746548fe28c6835e78a0fb05689"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f4bc05cbb5ce37733d6248f64e6bb1553a539f7ebb67dbe3b828019b4e561714"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), ".cmdpinact"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}pinact --version")

    (testpath"action.yml").write <<~YAML
      name: CI

      on: push

      jobs:
        build:
          runs-on: ubuntu-latest
          steps:
            - uses: actionscheckout@v3
            - run: npm install && npm test
    YAML

    system bin"pinact", "run", "action.yml"

    assert_match(%r{.*?actionscheckout@[a-f0-9]{40}}, (testpath"action.yml").read)
  end
end