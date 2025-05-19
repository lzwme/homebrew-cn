class Slumber < Formula
  desc "Terminal-based HTTPREST client"
  homepage "https:slumber.lucaspickering.me"
  url "https:github.comLucasPickeringslumberarchiverefstagsv3.1.1.tar.gz"
  sha256 "b7e6bdaae2ba181d5cb213cd1b8bb6e5e1341728bd26e74ca4b692537d4a7ead"
  license "MIT"
  head "https:github.comLucasPickeringslumber.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad7bc8e3e46c086a4c93d814795f928cb0418ad45f55b0c4e1ca4214f5846cb3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "e1e060c547138ec5e31af522468cd29436bea9cfde5d8e5c15204fa49f279046"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "768f586f80d8ab02c5bf47e936c137c858603a4db27ce80ee639c97bee96fa86"
    sha256 cellar: :any_skip_relocation, sonoma:        "0ef040f0e33616c051a6f7d19981829beb1747f4a55fb992157bebe3272076fc"
    sha256 cellar: :any_skip_relocation, ventura:       "6f44f9edc62c191099861448a54b88272fa186af63f5b69970dafbf57633a030"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "27721677aa58690109c4a1987c1b4307d4bc664562c76532e4591b40ffcbc7e5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a4872dd735264feecacf8bc029d273dc2776987613d9b672478b2521d1581f48"
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