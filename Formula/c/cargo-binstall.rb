class CargoBinstall < Formula
  desc "Binary installation for rust projects"
  homepage "https://github.com/cargo-bins/cargo-binstall"
  url "https://ghfast.top/https://github.com/cargo-bins/cargo-binstall/archive/refs/tags/v1.15.3.tar.gz"
  sha256 "f56fdfcf3471e494c83e1ed14006de7013decaf8a1a662800a0ce670c55c8f05"
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
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d2617647237ccb9cdafaf43ad18cb4a3146d8110341620624c4c0990cd01e92b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c29c1b6e7ad6ede1ef9a52e1c26a5ab2698cdedfd9d15413799d59ffc2e3b48e"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "743304c67c71a12e8dc24c161bc81dfc0668f4e523cd145cbc1e1d6e816d3d2b"
    sha256 cellar: :any_skip_relocation, sonoma:        "d0e6af4ed20f90c3550bfb3c32c77ace0b7c191bdf09ed529daa3cc93c417c22"
    sha256 cellar: :any_skip_relocation, ventura:       "73019e9360cf0f5214b9f8af989fe958d176698621c071e6e3a63ea81ed7d3d7"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2d8654faab8aade55171bb263eec4a2625e85942dc4619d49cabfa0cec502e8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9dc45c5f2f57fcddc08ffa1f1c60e30c99b9b302c4a87c9ca74680188026312e"
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