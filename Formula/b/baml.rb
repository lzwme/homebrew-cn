class Baml < Formula
  desc "Programming language for agents"
  homepage "https://boundaryml.com/"
  url "https://ghfast.top/https://github.com/BoundaryML/baml/archive/refs/tags/baml-wrapper-0.2.3.tar.gz"
  sha256 "30099f47ca63b69b29fec0a99e81a1af992b56da73a435ae9e9c3f7022de8e91"
  license "Apache-2.0"
  head "https://github.com/BoundaryML/baml.git", branch: "canary"

  livecheck do
    url :stable
    regex(/^baml-wrapper[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "660380f328caad0dd59c8adea28e6963020450389ffd3c962591ff309402df0a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a5eb6c9978f9d8e83a097f88f70f3a96e7d630a83452875d5ab3deb6a029152"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a0f6d09bae57fec7301fcf1a0ef78ef8d40c58f0ac6c0aefca34730ab669cbcc"
    sha256 cellar: :any_skip_relocation, sonoma:        "94f93f1e07d68e9704e9d9948670938770d3ae03dbdcd41c05ce85cad0f21e77"
    sha256 cellar: :any,                 arm64_linux:   "201f221371052a39740b912dc3bcbbbf0c3a38029971837fd562745d80cb29b1"
    sha256 cellar: :any,                 x86_64_linux:  "289d7e0f497c6010680bfb3472e06679fb8ae1a2f89a859ec81355d27985ff37"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(
      path:     "baml_language/crates/baml",
      features: "no-self-update",
    )
  end

  test do
    ENV["BAML_HOME"] = testpath/"baml-home"
    ENV.delete "BAML_VERSION"

    system bin/"baml", "toolchain", "use", "canary"
    shell_output("#{bin}/baml run -e 'baml.sys.exit(42)'", 42)
    assert_match "self-update is disabled in this build",
                 shell_output("#{bin}/baml self-update 2>&1", 1)
  end
end