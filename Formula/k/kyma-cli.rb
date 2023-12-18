class KymaCli < Formula
  desc "Kyma command-line interface"
  homepage "https:kyma-project.io"
  url "https:github.comkyma-projectcliarchiverefstags2.20.1.tar.gz"
  sha256 "5648038946088c0ed0901bd0ff04bfadb25cbbf33230e760e580671fd59ef8c1"
  license "Apache-2.0"
  head "https:github.comkyma-projectcli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0918ccc8e9a45f76e838edfb13bc159450eb4fc6cb6bcd16213df16b13500b22"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f39181a658a083e651f60e92fd84b7e65d0cd6b3aaf8e64fad2aca04668fda44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ffc8b44fdd235f0f5c1aec12e23444d92b5dd7b77695c4367fd2feff74a69a2"
    sha256 cellar: :any_skip_relocation, sonoma:         "68404112b471b6d1e2f1879092338bb1561ebb28d819f6d0e5244f8d139a44c8"
    sha256 cellar: :any_skip_relocation, ventura:        "97a3720ff5f7d6fec1362506320c6bc60ad3ee02bcf24dcea8be92e253618aeb"
    sha256 cellar: :any_skip_relocation, monterey:       "5ebb842b0d2266545ed22cc2e63fd9d015fda4f7b0d15be9921b3205759a4633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74af6a05f1eb43b4c891e85b9f55c9c7950b5dca6093de9d8363ffa4e03019e7"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comkyma-projectclicmdkymaversion.Version=#{version}
    ]

    system "go", "build", *std_go_args(output: bin"kyma", ldflags: ldflags), ".cmd"

    generate_completions_from_executable(bin"kyma", "completion", base_name: "kyma")
  end

  test do
    touch testpath"kubeconfig"
    assert_match "invalid configuration",
      shell_output("#{bin}kyma deploy --kubeconfig .kubeconfig 2>&1", 2)

    assert_match "Kyma CLI version: #{version}", shell_output("#{bin}kyma version 2>&1", 2)
  end
end