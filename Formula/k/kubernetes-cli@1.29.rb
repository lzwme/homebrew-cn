class KubernetesCliAT129 < Formula
  desc "Kubernetes command-line interface"
  homepage "https:kubernetes.iodocsreferencekubectl"
  url "https:github.comkuberneteskubernetes.git",
      tag:      "v1.29.12",
      revision: "9253c9bda3d8bd76848bb4a21b309c28c0aab2f7"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(^v?(1\.29(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "13d51814b87884402f416df5e9db0064fe88192bf6cf236e1493223d7fa754c8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "4a4a8c61723514af4c2df474bd70e7f04ea9933d75c630b1640ce5b1a8a8a981"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b1043ecdd2a7bcbbfd8cf271318750e1a3bc70c6487e233a0a714952cc07a1b7"
    sha256 cellar: :any_skip_relocation, sonoma:        "42629f96ca49096be4b30d61a6b064879843f5d7d3c109107ed961cfd257303c"
    sha256 cellar: :any_skip_relocation, ventura:       "8394e71d175a6f9dff918e4141e5cbd238685a697150b574f0052165a5807544"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "11b8f241a740a218efb53fa29abe0a12cb23cd1c116f2f399da4ba75009511ed"
  end

  keg_only :versioned_formula

  # https:kubernetes.ioreleasespatch-releases#1-29
  disable! date: "2025-02-28", because: :deprecated_upstream

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