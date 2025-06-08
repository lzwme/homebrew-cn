class Slumber < Formula
  desc "Terminal-based HTTPREST client"
  homepage "https:slumber.lucaspickering.me"
  url "https:github.comLucasPickeringslumberarchiverefstagsv3.1.3.tar.gz"
  sha256 "bfe9ae09d8220bc4aa19f2525585afc17c64ced069c1dc670c32c2ae817078cc"
  license "MIT"
  head "https:github.comLucasPickeringslumber.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cb9e7d2fb6f72272ee0dd27fcbb5601e878b6daa1c564c7dc4a315fc3dc70146"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2bc67b9511473c9217ebe903a8fd86c5f604706af606cbe94c6bd8477dfd4304"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "661379a5e733966a9e43c28cfe9800174f0eb053c3cb2a928fad1ccf8d8df444"
    sha256 cellar: :any_skip_relocation, sonoma:        "13c275e1499104eb2e86924a2b26bb6e9241fc57575aeb03ae2ad7d6a5610138"
    sha256 cellar: :any_skip_relocation, ventura:       "cd9e336a19ab470981179d0117baaa2d12e6f98cca1613d31b544ab6ef361488"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3502913ff76389d530d9bc3e4311629a38c2b4dd2e07c1c7f2e0fb77f07ba978"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a2b52044c6b55a0021305c41800d11c4251e55a16afb3895b6f28af8892ef2f1"
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