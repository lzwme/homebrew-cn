class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.15.8.tar.gz"
  sha256 "09ed6ff83a99f1e1c89ff991ea6fbb5a8597820f5c362deaf1a3c8921bec6ca2"
  license "GPL-3.0-only"
  head "https://github.com/cargo-bins/cargo-binstall.git", branch: "main"

  # Upstream creates releases that use a stable tag (e.g., `v1.2.3`) but are
  # labeled as "pre-release" on GitHub before the version is released, so it's
  # necessary to use the `GithubLatest` strategy.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "2b9a359a0fcff4c2cbff6b72a40913285c55752d98ef26daf01213ccdf732d27"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "45af45e589304e0026ed2922da325d704eeb437c7f01e5b49440522d740e2b7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "675d233af1adbbc7154aa093757c0d747da2dfb79263b11e4f108e0c3bdfe2c7"
    sha256 cellar: :any_skip_relocation, sonoma:        "9d42855e8ef52d0d1a6ec788c3f77f775ce4c7f0da5b9001f65cd1a7653d933b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3fbe4e7c357a4f4dbea7217127ce9cb956cb21f7edf153e44a6d36694de0b5bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5319fa38fd120408ce27905f88fc280ce79284fedc3420d7e56477ab040ed2e1"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    ENV["BINSTALL_DISABLE_TELEMETRY"] = "true"

    output = shell_output("#{bin}/cargo-binstall --dry-run radio-sx128x")
    assert_match "resolve: Resolving package: 'radio-sx128x'", output

    assert_equal version.to_s, shell_output("#{bin}/cargo-binstall -V").chomp
  end
end