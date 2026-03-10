class Prek < Formula
  desc "Pre-commit re-implemented in Rust"
  homepage "https://github.com/j178/prek"
  url "https://ghfast.top/https://github.com/j178/prek/archive/refs/tags/v0.3.5.tar.gz"
  sha256 "3d0bf93af3591762b2fce97965fb88f8dc4b750164451162f57f866e26e4bb67"
  license "MIT"
  head "https://github.com/j178/prek.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c3f01172c12e7c3cd7a53471b8d595bbb4bc5d7c6c646e73315d12901e4ff9e8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "685d4140f0ef6ef9ab1ad15c8e582491642a89bb21ce0d99382eaebee4eb397c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e4cc1b257eaf03666e082c9f3ba6bfacbb571be266de37d6af36826b5f85e4b0"
    sha256 cellar: :any_skip_relocation, sonoma:        "b871f62edf026b9e361020d8f59a608b74ce47bd56e46287b6253d28948abfb4"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "550677da7ec81d03bd23371006d40c606373c14cf38aee6e66f09088fe203f10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6e43a10c56245f5cf7d069b47df8118d78b1e195d67de40c4994c7058e450b24"
  end

  depends_on "rust" => :build

  def install
    ENV["PREK_COMMIT_HASH"] = ENV["PREK_COMMIT_SHORT_HASH"] = tap.user
    ENV["PREK_COMMIT_DATE"] = time.strftime("%F")
    system "cargo", "install", *std_cargo_args(path: "crates/prek")
    generate_completions_from_executable(bin/"prek", shell_parameter_format: :clap)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/prek --version")

    output = shell_output("#{bin}/prek sample-config")
    assert_match "See https://pre-commit.com for more information", output
  end
end