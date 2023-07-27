class Pgrok < Formula
  desc "Poor man's ngrok, multi-tenant HTTP/TCP reverse tunnel solution"
  homepage "https://github.com/pgrok/pgrok"
  url "https://ghproxy.com/https://github.com/pgrok/pgrok/archive/refs/tags/v1.3.4.tar.gz"
  sha256 "2da14eeae3d9678bffd27ca5cf3900bf2c041628cbccae939137d73f0522d747"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd0c980acfad5f0143ab6cddc9dcad9ca13d3eb8407bba1d15f5a8388126f277"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cd0c980acfad5f0143ab6cddc9dcad9ca13d3eb8407bba1d15f5a8388126f277"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cd0c980acfad5f0143ab6cddc9dcad9ca13d3eb8407bba1d15f5a8388126f277"
    sha256 cellar: :any_skip_relocation, ventura:        "20d51f1beedf32126d8a341ee641a46ed42fd65d558697330748bd9364dead5a"
    sha256 cellar: :any_skip_relocation, monterey:       "20d51f1beedf32126d8a341ee641a46ed42fd65d558697330748bd9364dead5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "20d51f1beedf32126d8a341ee641a46ed42fd65d558697330748bd9364dead5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65e23e4764286f3efef2fbb1fb275253ea9f7557fb9e0e518306654805a5cb8f"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.date=#{time.iso8601}
    ]

    ["pgrokd", "pgrok"].each do |f|
      system "go", "build", *std_go_args(ldflags: ldflags, output: bin/f), "./cmd/#{f}"
    end

    etc.install "pgrok.example.yml"
    etc.install "pgrokd.exmaple.yml"
  end

  test do
    ENV["XDG_CONFIG_HOME"] = testpath

    output = shell_output("#{bin}/pgrokd --config #{etc}/pgrokd.exmaple.yml 2>&1", 1)
    assert_match "[error] failed to initialize database", output

    system bin/"pgrok", "init", "--remote-addr", "example.com:222",
                                "--forward-addr", "http://localhost:3000",
                                "--token", "brewtest"
    assert_match "brewtest", (testpath/"pgrok/pgrok.yml").read

    assert_match version.to_s, shell_output("#{bin}/pgrok --version")
  end
end