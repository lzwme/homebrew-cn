class Clarinet < Formula
  desc "Command-line tool and runtime for the Clarity smart contract language"
  homepage "https:www.hiro.soclarinet"
  url "https:github.comhirosystemsclarinetarchiverefstagsv2.11.1.tar.gz"
  sha256 "8a134c712d234bb89ff7fa035972cee1215b8d3e1e372bf8944291e47f3d9cd0"
  license "GPL-3.0-only"
  head "https:github.comhirosystemsclarinet.git", branch: "main"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bb187dc23ab84617d45e402f0b70a997207c9d3ec2e1bafb516ea2e700090d39"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8d301d3b47c2e437f65f5df11edcf781bd3238232f0772978e1d7969c1a9d66d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "196e925a899617f5c4c5cdfcc7475f70e739a7c3b732d4d4bb558badf44d8a44"
    sha256 cellar: :any_skip_relocation, sonoma:        "c6fe43a5bee7e73fe31f6fec45c8067de9f7b41aa75bbd66c45b200cf60dda44"
    sha256 cellar: :any_skip_relocation, ventura:       "416482cc703b77cf192cc181d33506fca6806c389da67ab31c9a3a5db8ea262f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "032586d59afe5e7362312ea7d96aa7e6124ef8e3cebfedc41735569041563f11"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "componentsclarinet-cli")
  end

  test do
    pipe_output("#{bin}clarinet new test-project", "n\n")
    assert_match "name = \"test-project\"", (testpath"test-projectClarinet.toml").read
    system bin"clarinet", "check", "--manifest-path", "test-projectClarinet.toml"
  end
end