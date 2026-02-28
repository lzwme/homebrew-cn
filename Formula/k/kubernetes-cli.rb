class KubernetesCli < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.35.2",
      revision: "fdc9d74cbf2da6754ebf81d56f80ae2948cd6425"
  license "Apache-2.0"
  head "https://github.com/kubernetes/kubernetes.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b046e3185705e96be7638188f2bf3efd7512d13f0f40c1d302c81d5a065db203"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "490a1510146b7934f8df0e2beb3d6cbdb031d5be65637f3b86c3ef2bea6633a9"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "3be2d48bb3edbadd8be2016ec123b832ef474f16c7d50f698347361926d13bc0"
    sha256 cellar: :any_skip_relocation, sonoma:        "5f23cb8f756876049e693128cad01255e9348fb2c4a67a7ab7459dbe6b6ff00d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a5aa9b04a45c8099f88574214502c9a7db4457db8f30c75b93cad8760c3a99b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5353f4e92bc86fc3fceae57e8115dd8725e55474a1c61f73d0502a70a50693b4"
  end

  depends_on "go" => :build

  uses_from_macos "rsync" => :build

  on_macos do
    depends_on "bash" => :build
    depends_on "coreutils" => :build
  end

  def install
    ENV.prepend_path "PATH", Formula["coreutils"].libexec/"gnubin" if OS.mac? # needs GNU date
    ENV["FORCE_HOST_GO"] = "1"
    system "make", "WHAT=cmd/kubectl"
    bin.install "_output/bin/kubectl"

    generate_completions_from_executable(bin/"kubectl", shell_parameter_format: :cobra)

    # Install man pages
    # Leave this step for the end as this dirties the git tree
    system "hack/update-generated-docs.sh"
    man1.install Dir["docs/man/man1/*.1"]
  end

  test do
    run_output = shell_output("#{bin}/kubectl 2>&1")
    assert_match "kubectl controls the Kubernetes cluster manager.", run_output

    version_output = shell_output("#{bin}/kubectl version --client --output=yaml 2>&1")
    assert_match "gitTreeState: clean", version_output
    assert_match stable.specs[:revision].to_s, version_output
  end
end