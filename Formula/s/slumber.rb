class Slumber < Formula
  desc "Terminal-based HTTP/REST client"
  homepage "https://slumber.lucaspickering.me/"
  url "https://ghfast.top/https://github.com/LucasPickering/slumber/archive/refs/tags/v4.3.0.tar.gz"
  sha256 "deb67f24efd7fa689acfef8d52bc69c29873735aedc549f0c7220f9d1ccfffc8"
  license "MIT"
  head "https://github.com/LucasPickering/slumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5fc44b76bf23fcfe89612250a6ec551bb7ac93e4002f1af3b10003d770ed046d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b7fba3c6320df0e7c01ddd24f87bb5529db59822a733c8ebd47cb655a70defd4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "08d81c112273d4196ab9f957e3b24b40b98c9077053222c31c2f53223cd6f3dc"
    sha256 cellar: :any_skip_relocation, sonoma:        "8301b436f36b540853359ecb4305207789b7923584e1587750db7be539f7e277"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3b13d1f50493a828e3725ad81c13aa879401a02138379fc13be2119f272b55ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f0c0d60786716e50bd47e4cb0a030a5974641c55222aacd17d1dcf42171e017d"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/slumber --version")

    system bin/"slumber", "new"
    assert_match <<~YAML, (testpath/"slumber.yml").read
      profiles:
        example:
          name: Example Profile
          data:
            host: https://my-host
    YAML
  end
end