require "language/node"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https://bitwarden.com/"
  url "https://registry.npmjs.org/@bitwarden/cli/-/cli-2024.4.1.tgz"
  sha256 "ef0e16a7cf666cf74dbc1f134297e615af45c469eae5dc1355e2c4abc66c6338"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2473265731aa258e649782345cc422ab18717e53c536e5d94fcc0c3eed8007a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f70ee5d747e992712f268ea3901b08dc3ba5e6c8498ae441d8b83f8d275c519"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8a150ace2bba7526e0346b92f9476279083faa5054a860cb52f77a5fd67c51a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "9b05a7918d9af9b9970d4d611ef61d58deee4bc1e375da7ffac7d73f1d0e54bd"
    sha256 cellar: :any_skip_relocation, ventura:        "2e87139af0e2811e98568e6b223b45e4191dd93558662ef5396e062dc947b57e"
    sha256 cellar: :any_skip_relocation, monterey:       "30c35d61ac5c7bdc34c3ab6c44f5ebcd34d692166c5ec62894b635e449c3d7b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29cf145ccf631b8a5128fedeeee8146183bb559f8a2a7449f288fba5b8e5a032"
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