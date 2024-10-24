class KubernetesCliAT130 < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.30.6",
      revision: "00f20d443ba0cbc485d6ce36a7d3f9a9c4e8ed7a"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(1\.30(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f6ce571104f69c6ffa28bd6a15503a88e32a718f9533fcff74d23adb9e0972ee"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "835291d94630e8feba855c639788d6f39272109420bfca9fd83141a2b423b8b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "387a1964cc93d5d4dbe3c27b473add5d829706098fa23ba842ff253dbd0c43f8"
    sha256 cellar: :any_skip_relocation, sonoma:        "3eb7bba78a05aedc16d7514c908df42f95f3c8890ab357f7be9c459016f25ed8"
    sha256 cellar: :any_skip_relocation, ventura:       "4062e42691b3e69ed00db5fe8e061ff1f94ba14a02976aee4b133fa9f527f246"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "89710e84c1cf0fc9b61f184d806a04102329e15fc58b4cb5c5a7ede47b5ead94"
  end

  keg_only :versioned_formula

  # https:kubernetes.ioreleasespatch-releases#1-30
  disable! date: "2025-06-28", because: :deprecated_upstream

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

    generate_completions_from_executable(bin"kubectl", "completion", base_name: "kubectl")

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