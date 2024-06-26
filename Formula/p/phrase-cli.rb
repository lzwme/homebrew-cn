class PhraseCli < Formula
  desc "Tool to interact with the Phrase API"
  homepage "https:phrase.com"
  url "https:github.comphrasephrase-cliarchiverefstags2.29.0.tar.gz"
  sha256 "b2e43ef456312d070a9c4ea2400dde9b95ec523693f387fded28d25fea1fad91"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd6e4aabe865ca40eb2cecb4453a5a03883f5de134a9b3f789d45a7a197c5d6b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2fdcb31fd5dc57508dfef5623030c6da53014d840a00882dcc40e0881b687260"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "687164cf0e4cb3e8e2c8a353e79c7ae8212ed0dc53911456c33877d498115924"
    sha256 cellar: :any_skip_relocation, sonoma:         "13c6dd9be804d27588bd216df1354b1b346290d7532e8e62dabb6c0068d86f73"
    sha256 cellar: :any_skip_relocation, ventura:        "d565e131c5c37184bfc338450a6ff292ef5c3d34d77f0ca3ad2d07e4dfa94cda"
    sha256 cellar: :any_skip_relocation, monterey:       "233f0572aeb8f018252345d7921ad43947b8f864584d39ee10c78d7bf16b9d30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5bf8135ae5fb4943f9b5abb7d2ac4743fd5b9e65b90dfc0ae23bbc0a4930de6"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comphrasephrase-clicmd.PHRASE_CLIENT_VERSION=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)
    bin.install_symlink "phrase-cli" => "phrase"

    generate_completions_from_executable(bin"phrase", "completion", base_name: "phrase", shells: [:bash])
  end

  test do
    assert_match "ERROR: no targets for download specified", shell_output("#{bin}phrase pull 2>&1", 1)
    assert_match version.to_s, shell_output("#{bin}phrase version")
  end
end