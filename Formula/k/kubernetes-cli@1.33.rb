class KubernetesCliAT133 < Formula
  desc "Kubernetes command-line interface"
  homepage "https://kubernetes.io/docs/reference/kubectl/"
  url "https://github.com/kubernetes/kubernetes.git",
      tag:      "v1.33.9",
      revision: "69220b617523ac1ba5d070e74c12b5daf5e6c572"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(1\.33(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "1c9178added395ce18b2a3da75a0bc5c712cdc817670ad357c2301af4e24b078"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "dc15c3f3ede684a67eb5a4a3174b1f643f0d10b1d53acb21efacfbe11512ecd0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "99d61e191ca0907f97d8cf0cf33296f671ecdb5fb16120ee5cc8f0eec4ba0b66"
    sha256 cellar: :any_skip_relocation, sonoma:        "fcc57322c5d46db3582e69413aa75e638ce112db996bec80430404b5a9b25dc2"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "20910d8c33d1ef5d5d3ceb8970939fc4b860a6d804bfc3100d177f61c0e01967"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f1eeee62a46c09cc2434343b4bb3765166b11c3eb3938fb939364a427aa1dedb"
  end

  keg_only :versioned_formula

  # https://kubernetes.io/releases/patch-releases/#1-33
  disable! date: "2026-06-28", because: :deprecated_upstream

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