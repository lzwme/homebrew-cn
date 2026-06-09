class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.20.0.tar.gz"
  sha256 "b10b4892be05f2ad2a8ae681f187bb3b90c7c6baa056cf1f244c8ff308fd786f"
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
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ada74a3d7587271a48a18c16e32103eed6ebb03b43fd0cbf45b53d8cdac03fa3"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ba9962ac12e4f08e16063572e8460b68a0b5b0cbbb46e6edfcd0051f4f59ebb9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c7f88571793ea82bb5adaea82bfbe9951c55e6a810cf41b8a59db1651c3b9a6d"
    sha256 cellar: :any_skip_relocation, sonoma:        "e61905f103f5e14fd3f5292cea008882af42a474c3c4dcf17e77a403673f2232"
    sha256 cellar: :any,                 arm64_linux:   "9a058b4d2b184d55b6e6ca9ad570c4b8a3edf5c1a82019a08c02ae910080ef41"
    sha256 cellar: :any,                 x86_64_linux:  "fa5d68ebd34443f609e185de61429600d50d78e3698fd1b0eeb9547c2a487f85"
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