class Pkl < Formula
  desc "CLI for the Pkl programming language"
  homepage "https:pkl-lang.org"
  url "https:github.comapplepklarchiverefstags0.26.2.tar.gz"
  sha256 "f3b57e744eb6b7d2976fe81c04d4f496a76ef69c1a21b7287771c6ec9bf533c6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4f342f0b0705348b3a117a556c54d7507c232f1954643957e0f974d5d2dd7a0f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95723a4e52511a72875e7e6247e3caaaf8ae5b9e3c599a67716e164b3c4be7c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b95845d305f20920ed31d6a277228f49603b7c1d4cfc4d264b7abead3a5fe8f9"
    sha256 cellar: :any_skip_relocation, sonoma:         "aca2659df73f9633ea360b912ab75c87be729606cbea388f581654e7552e0f8c"
    sha256 cellar: :any_skip_relocation, ventura:        "06441f831c8df31e09ccc65f54d33426239e63cf1d327a5cb5c8622f2f511eba"
    sha256 cellar: :any_skip_relocation, monterey:       "370265b58dec92cdbf9a173a67ac6853e54c0489d31d1b63d6bccfb56011f280"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6073660a32d15af78f1c5169969596aa93f799b4203b4c8fe208ed76de62965f"
  end

  # Can change this to 21 in later releases.
  depends_on "openjdk@17" => :build

  uses_from_macos "zlib"

  def install
    ENV["JAVA_HOME"] = Formula["openjdk@17"].opt_prefix
    # Need to set this so that native-image passes through env vars when calling out to the C toolchain.
    ENV["NATIVE_IMAGE_DEPRECATED_BUILDER_SANITATION"] = "true"

    arch = Hardware::CPU.arm? ? "aarch64" : "amd64"
    job_name = "#{OS.mac? ? "mac" : "linux"}Executable#{arch.capitalize}"

    system ".gradlew", "-DreleaseBuild=true", job_name
    bin.install "pkl-clibuildexecutablepkl-#{OS.mac? ? "macos" : "linux"}-#{arch}" => "pkl"
  end

  test do
    assert_equal "1", pipe_output("#{bin}pkl eval -x bar -", "bar = 1")

    assert_match version.to_s, shell_output("#{bin}pkl --version")
  end
end