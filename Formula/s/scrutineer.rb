class Scrutineer < Formula
  desc "Security through scrutiny"
  homepage "https://github.com/alpha-omega-security/scrutineer"
  url "https://ghfast.top/https://github.com/alpha-omega-security/scrutineer/archive/refs/tags/v2026.09.08.1.tar.gz"
  sha256 "d6169140d26d2c1a08fd816bb3d911c14457616bbe1cf06ec8ade3a3a21cd157"
  license "MIT"
  head "https://github.com/alpha-omega-security/scrutineer.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f4ed123e93b3c619679917c5608b20064c70b550f9b95b3c1359f1d602ddd772"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f4ed123e93b3c619679917c5608b20064c70b550f9b95b3c1359f1d602ddd772"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f4ed123e93b3c619679917c5608b20064c70b550f9b95b3c1359f1d602ddd772"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b9e486df21dd05f941fa5845f7b98bd7293434d92cd74aff5b37a34dd7e512bb"
    sha256 cellar: :any,                 x86_64_linux:  "0da55a99140b9f1a3d73070619c0f919fe59e1c42973959ec8b6d494985be7e4"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.commit=#{tap.user}
      -X main.buildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:), "./cmd/scrutineer"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/scrutineer version")

    output = shell_output("#{bin}/scrutineer -runtime brew 2>&1", 1)
    assert_match "runtime: must be \\\"docker\\\", \\\"podman\\\", or \\\"apple\\\"", output
  end
end