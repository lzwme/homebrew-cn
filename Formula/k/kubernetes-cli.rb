class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.32.2",
      revision: "67a30c0adcf52bd3f56ff0893ce19966be12991f"
  license "Apache-2.0"
  head "https:github.comkuberneteskubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "00fd56b9f5c21d7f40a108098250966473964799ff49d3dbdf36cbeea9d21c50"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "57c3b6092968f32a1f3e0afa5676e6f16b3104791a07d9d6279a5c189005c92f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d06fe95ec38c54318a8a66b498e76636cd22101eaed1c131c2746a093ce9fabb"
    sha256 cellar: :any_skip_relocation, sonoma:        "aaf45466833d93aec0e1a938d68d8bbde124a9005b79c1273be0aa8e1c104169"
    sha256 cellar: :any_skip_relocation, ventura:       "9a368ff1bde1191d76d7bb5a888b8100b43727bd5c3566e54ce81e21df956045"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "285e1752fd4403fc3a0870d7b3dac36b4029e5bdb3d352e3469b08650e121dc4"
  end

  depends_on "bash" => :build
  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  on_macos do
    depends_on "coreutils" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec"gnubin" if OS.mac? # needs GNU date
    ENV["FORCE_HOST_GO"] = "1"
    system "make", "WHAT=cmdkubectl"
    bin.install "_outputbinkubectl"

    generate_completions_from_executable(bin"kubectl", "completion")

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hackupdate-generated-docs.sh"
    man1.install Dir["docsmanman1*.1"]
  end

  test do
    run_output = shell_output("#{bin}kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}kubectl version --client --output=yaml 2>&1")
    assert_match "gitTreeState: clean", version_output
    assert_match stable.specs[:revision].to_s, version_output
  end
end