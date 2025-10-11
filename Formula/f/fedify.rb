class Fedify < Formula
  desc "CLI toolchain for Fedify"
  homepage "https://fedify.dev/cli"
  url "https://ghfast.top/https://github.com/fedify-dev/fedify/archive/refs/tags/1.8.13.tar.gz"
  sha256 "8b04aca6f3ebf8395987be1925e5d22158f047a855aa070551a7e3e4e90d5887"
  license "MIT"
  head "https://github.com/fedify-dev/fedify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5237ca6bfae59e3e15e1c60735e6792c50c2ac2b2d9d38c90a625411f473f7b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d82e7f86315ee983c73dc9bd74dc845d4cfb2cf677d405e9f5a8df9284fff218"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "84bc584005db4c42a4c9b14df5fd2fb3015f2146d6cc36388d15b1f2fe17bfdd"
    sha256 cellar: :any_skip_relocation, sonoma:        "8310c96e13bc186873d988d936d8aae4a65f0b397b19cf00babc28a923627fad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dd847872f8256f798b0028204f5e54d1a1acf2c099eb72b235e67f96e7895fae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "05bd1fb2f5a7e6a08514d1e4aa6cb4823f5935828a6602b75686eb58ecf5e36d"
  end

  depends_on "deno" => :build

  def install
    system "deno", "task", "codegen"
    system "deno", "compile", "--allow-all", "--output=#{bin/"fedify"}", "packages/cli/src/mod.ts"
    generate_completions_from_executable(bin/"fedify", "completions")
  end

  test do
    # Skip test on Linux CI due to environment-specific failures that don't occur in local testing.
    # This test passes on macOS CI and all local environments (including Linux).
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"]

    version_output = shell_output "NO_COLOR=1 #{bin}/fedify --version"
    assert_equal "fedify #{version}", version_output.strip

    json = shell_output "#{bin}/fedify lookup -e @homebrew@fosstodon.org"
    actor = JSON.parse(json)
    assert_equal "https://fosstodon.org/users/homebrew", actor.first["@id"]
  end
end