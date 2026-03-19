class Dasel < Formula
  desc "JSON, YAML, TOML, XML, and CSV query and modification tool"
  homepage "https://github.com/TomWright/dasel"
  url "https://ghfast.top/https://github.com/TomWright/dasel/archive/refs/tags/v3.3.2.tar.gz"
  sha256 "72cc6d106e92733f8bee9ac187e4eaf01f2283188432992a08bb435b848dd67b"
  license "MIT"
  head "https://github.com/TomWright/dasel.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "09b9264b1e8db8c3e39c0504e4b4973639eff0bf7b41835528cbbf1ffb9bb6b8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "09b9264b1e8db8c3e39c0504e4b4973639eff0bf7b41835528cbbf1ffb9bb6b8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "09b9264b1e8db8c3e39c0504e4b4973639eff0bf7b41835528cbbf1ffb9bb6b8"
    sha256 cellar: :any_skip_relocation, sonoma:        "1a273446d422dfb1a48aeba9923d308aada31a2f7f0e0c3b233ae47ce2c43b87"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "834d535a664a22e41ba9f1f750c9d408c492ce40cd6e3eaa868223103ad73b6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c57308ef72f1118b9a5ce256cb97337aad4dd41fd5153975f80f27c5ff11a3a7"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/tomwright/dasel/v#{version.major}/internal.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/dasel"
  end

  test do
    assert_equal "\"Tom\"", pipe_output("#{bin}/dasel -i json 'name'", '{"name": "Tom"}', 0).chomp
    assert_match version.to_s, shell_output("#{bin}/dasel version")
  end
end