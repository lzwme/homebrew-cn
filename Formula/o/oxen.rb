class Oxen < Formula
  desc "Data VCS for structured and unstructured machine learning datasets"
  homepage "https://www.oxen.ai/"
  url "https://ghfast.top/https://github.com/Oxen-AI/Oxen/archive/refs/tags/v0.38.1.tar.gz"
  sha256 "994b4effb945111212b4b638d4b4a560c48eb6745b8f0e559ea8e10adc67b555"
  license "Apache-2.0"
  head "https://github.com/Oxen-AI/Oxen.git", branch: "main"

  # The upstream repository contains tags that are not releases.
  # Limit the regex to only match version numbers.
  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "eb3fb2c8e1143d26ae08d5376e7fe7b154fc64ca2ba7e0fb1921347157e3a49c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "3a0e915180038cc6aca18d1023980f8e04b647900d08c1717333bf77cca99d5a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f66c92812085d3e96611e34bd90ebb5b3299ba50e0b737b16725828469f617a1"
    sha256 cellar: :any_skip_relocation, sonoma:        "6a3683ebbc34d1def9a2c9edd04e8cb6951ebcd414d84532fe8cb44bab7711fb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "769aa5051a477e96fabc9617a7dd56a7ddc9c78844d95a120a3c28ee6a6a49b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c1c9e42a7f9c13bc9e9d2244931d62934a16958d75b0ef8cb672cbfe2a315529"
  end

  depends_on "cmake" => :build # for libz-ng-sys
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "xz"

  uses_from_macos "bzip2"
  uses_from_macos "llvm" # for libclang

  on_linux do
    depends_on "openssl@3"
  end

  def install
    cd "oxen-rust" do
      system "cargo", "install", *std_cargo_args(path: "src/cli")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/oxen --version")

    system bin/"oxen", "init"
    assert_match "default_host = \"hub.oxen.ai\"", (testpath/".config/oxen/auth_config.toml").read
  end
end