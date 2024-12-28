class Slumber < Formula
  desc "Terminal-based HTTPREST client"
  homepage "https:slumber.lucaspickering.me"
  url "https:github.comLucasPickeringslumberarchiverefstagsv2.4.0.tar.gz"
  sha256 "22a8589b4adb7820870b888a72d2c2bdf139ea1613d87397f2652167759cb505"
  license "MIT"
  head "https:github.comLucasPickeringslumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a63d3bf6167eb6f9c62056365aa0877920ad8da5873811e9bb4ab1d3c31c4fa0"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7c887d636466785d46ba981c1611461b304a1edcb0047150a8de0974d5ff3b4f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1eee5c503f0aaec6eff40c135b6ccea2921f25c6316c8a00ac2e497c0a05f934"
    sha256 cellar: :any_skip_relocation, sonoma:        "1b42e60466ee73b26550e35ff1f3933cb6435993252eae3dba246723aaf54ffb"
    sha256 cellar: :any_skip_relocation, ventura:       "7053df3d88e4a44f876fb732c980d37154d077f866be8fcef5efa499b8420f99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f6550d6a912b59a7f746dc136e737debb7c18efd1f040c043acd8b9771b9dd52"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}slumber --version")

    system bin"slumber", "new"
    assert_match <<~YAML, (testpath"slumber.yml").read
      # For basic usage info, see:
      # https:slumber.lucaspickering.mebookgetting_started.html
      # For all collection options, see:
      # https:slumber.lucaspickering.mebookapirequest_collectionindex.html

      # Profiles are groups of data you can easily switch between. A common usage is
      # to define profiles for various environments of a REST service
      profiles:
        example:
          name: Example Profile
          data:
            host: https:httpbin.org
    YAML
  end
end