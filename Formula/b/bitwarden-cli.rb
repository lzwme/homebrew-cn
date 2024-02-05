require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2024.1.0.tgz"
  sha256 "0a4f2fd2b8b583952a4a448d13a6e7afb7dcb163a5526e8c9a92fbd80c459b97"
  license "GPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5d1e4d72898a43d9492c4ca1f4fb6c23f94a85afae7ff0a649f1fd88ad6f33be"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e88154fc05f0266ea7798821fb6d609f11bbf361aaa5820da2bfb6153957e841"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd9f661e229d0521e2b84a19c84c26b5d8750f2b125066a3293a68475351b9ff"
    sha256 cellar: :any_skip_relocation, sonoma:         "87b729cdccf5c17e104b09aaa84ff1bb7e141a5057db6b9374ec65d58eed24ef"
    sha256 cellar: :any_skip_relocation, ventura:        "46d8a2cfde6e9100b1dd9d2a30d2163e844cb7af83b05eb9b85b8d3a6cce46fd"
    sha256 cellar: :any_skip_relocation, monterey:       "82d0be8638adf477ec4ce784f36ccad2bcf29ea7eff423e9cdc7578bbe04bd40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "041a10ed22d81ef614ce9f134789881d2714bdd160dacfeb91d2ca2e99dff290"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    generate_completions_from_executable(
      bin/"bw", "completion",
      base_name: "bw", shell_parameter_format: :arg, shells: [:zsh]
    )
  end

  test do
    assert_equal 10, shell_output("#{bin}/bw generate --length 10").chomp.length

    output = pipe_output("#{bin}/bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end