class Baml < Formula
  desc "Programming language for agents"
  homepage "https://boundaryml.com/"
  url "https://ghfast.top/https://github.com/BoundaryML/baml/archive/refs/tags/baml-wrapper-0.2.2.tar.gz"
  sha256 "5c2169f69352bb9dd52cd7b4988eb76a7efd1fbfcc11fb41f2dc770d31dd8280"
  license "Apache-2.0"
  head "https://github.com/BoundaryML/baml.git", branch: "canary"

  livecheck do
    url :stable
    regex(/^baml-wrapper[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "de69b38f725b0e3fb07c6b9fc3815d4aa828093bf20b0dd3595817afa40fc623"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "94053fe3f793b16bfe0546365633bc68dee8ba56a69e208164899e1ca811d3fb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "94ab7c29be1a21d70d4dedb21488c69bf2609a688887b916609d470cfcdc7264"
    sha256 cellar: :any_skip_relocation, sonoma:        "f8d6196b0abe2960dbccbedc26444e10da90aef4c57cb6ae5671cf7a3a0ff216"
    sha256 cellar: :any,                 arm64_linux:   "b6f2fe530bf503f8f9efe7ec385681d2dd6efcf5b52408f02e77ba148b7fd1eb"
    sha256 cellar: :any,                 x86_64_linux:  "a9438a264f761ed8ebab75008a93cdda79e2d4f1a1921e2d094e4342c4024c85"
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