class Linkerd < Formula
  desc "Command-line utility to interact with linkerd"
  homepage "https://linkerd.io"
  url "https://github.com/linkerd/linkerd2.git",
      tag:      "stable-2.13.0",
      revision: "775dc9fbd9d9e1eb043f0ca613a66cdba8e316de"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^stable[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eb43993a15e3510858bde088ad47451c18bd11a111aacb22889eedba26fe7381"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d06ba28e1fce12755214d4b541b1badbbf467525fbf2570f147e046acc3dd4f4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f00c8c484451163c201b0aea8c58f256b7a90a70afc98caec095e0263bd6411c"
    sha256 cellar: :any_skip_relocation, ventura:        "955dd84a522a78f3b384aceca1f6d39d8d966846c14d1ef6c1f3c991d9af1b71"
    sha256 cellar: :any_skip_relocation, monterey:       "ee46e3489afb29280416b2c7e54c3162ed16b80e46660162c0af1288290db427"
    sha256 cellar: :any_skip_relocation, big_sur:        "a8fa36f49b807a469659f0d395ed5aa453efac8248e0594febe2d7f90d1964f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac7b6b303c8129c0e4ace6b83df55a307c98d97fb3dea7409a9a14dd4a3a5779"
  end

  depends_on "go" => :build

  def install
    ENV["CI_FORCE_CLEAN"] = "1"

    system "bin/build-cli-bin"
    bin.install Dir["target/cli/*/linkerd"]
    prefix.install_metafiles

    generate_completions_from_executable(bin/"linkerd", "completion")
  end

  test do
    run_output = shell_output("#{bin}/linkerd 2>&1")
    assert_match "linkerd manages the Linkerd service mesh.", run_output

    version_output = shell_output("#{bin}/linkerd version --client 2>&1")
    assert_match "Client version: ", version_output
    assert_match stable.specs[:tag], version_output if build.stable?

    system bin/"linkerd", "install", "--ignore-cluster"
  end
end