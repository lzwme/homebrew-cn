require "languagenode"

class BitwardenCli < Formula
  desc "Secure and free password manager for all of your devices"
  homepage "https:bitwarden.com"
  url "https:github.combitwardenclientsarchiverefstagscli-v2024.6.1.tar.gz"
  sha256 "1dff0f6af422864aa9a4e8c226282cb3f4346a4c8e661effe2571e1553603e56"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "711cc5ac937d834e59a007e4de78347a97c8acfdd94817bab1522a2a6740c8e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4b2ef0b7f9dbeea0ec9fe94290c5f5ee79f25ca087a76216a3d6efd5f22b1d3b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "12e01176eeca3dfb9bfcb82ae893f203a3672dbb450041116930e2e9daf3ec4b"
    sha256 cellar: :any_skip_relocation, sonoma:         "a81f956a41874b4aa6e9a0a342cbcda993b9511e76cda106c7300c1e49059539"
    sha256 cellar: :any_skip_relocation, ventura:        "c91323e71654a0753fb2b8cc555d84c1fa9ad9262108b92aa18e1bb5e0535b96"
    sha256 cellar: :any_skip_relocation, monterey:       "c31d3ee2ed80399a5f00c68a9590d32b80927f9a16eea49fa55f41b514e05f6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd14f3cbf054c40792b0f0b9e985fba9e99c20855dcc6e8ec79c4228a16fb18c"
  end

  depends_on "node"

  def install
    Language::Node.setup_npm_environment
    system "npm", "ci", "--ignore-scripts"
    cli_root = buildpath"appscli" # Bitwarden's source code is a monorepo
    cd cli_root do
      # The `oss` build of Bitwarden is a GPL backed build
      system "npm", "run", "build:oss:prod", "--ignore-scripts"
      cd cli_root"build" do
        system "npm", "install", *Language::Node.std_npm_install_args(libexec)
        bin.install_symlink Dir[libexec"bin*"]
      end
    end

    generate_completions_from_executable(
      bin"bw", "completion",
      base_name: "bw", shell_parameter_format: :arg, shells: [:zsh]
    )
  end

  test do
    assert_equal 10, shell_output("#{bin}bw generate --length 10").chomp.length

    output = pipe_output("#{bin}bw encode", "Testing", 0)
    assert_equal "VGVzdGluZw==", output.chomp
  end
end