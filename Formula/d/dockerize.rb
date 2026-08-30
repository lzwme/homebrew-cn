class Dockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/jwilder/dockerize"
  url "https://ghfast.top/https://github.com/jwilder/dockerize/archive/refs/tags/v0.15.0.tar.gz"
  sha256 "a3ca7a5c3ca31a24b7024ba4c78f419a18d0a183b6429251ebbf1f25edd6a973"
  license "MIT"
  head "https://github.com/jwilder/dockerize.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "705873f7b0ededa090899cc237ae8e3d2b5317762a8cbc29445f8ab396d2ca8b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "705873f7b0ededa090899cc237ae8e3d2b5317762a8cbc29445f8ab396d2ca8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "705873f7b0ededa090899cc237ae8e3d2b5317762a8cbc29445f8ab396d2ca8b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9063ebe34037a731834a6e467854e2760acbe5dda53427d673cec082366c6918"
    sha256 cellar: :any,                 x86_64_linux:  "2c6f0d62811ed43939bb0423d0b2e3e92708c2a4afc25257b33bb49a72d8259f"
  end

  depends_on "go" => :build
  conflicts_with "powerman-dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(ldflags: "-X main.buildVersion=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system bin/"dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end