class Ninja < Formula
  desc "Small build system for use with gyp or CMake"
  homepage "https:ninja-build.org"
  url "https:github.comninja-buildninjaarchiverefstagsv1.13.0.tar.gz"
  sha256 "f08641d00099a9e40d44ec0146f841c472ae58b7e6dd517bee3945cfd923cedf"
  license "Apache-2.0"
  head "https:github.comninja-buildninja.git", branch: "master"

  livecheck do
    url :stable
    regex(^v?(\d+(?:\.\d+)+)$i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "60f60dca4793f8f81a4ba72809d49ee79cfb36eed2eb0555dfd735a7af7396f3"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "357970eb2a15833392163be15cd02e9a76157df1b0bb98a5acd5e0ba8f49d468"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "532af454e1545c1ed766f6548501627ae77bbaf2e1195855837728b78d72bd89"
    sha256 cellar: :any_skip_relocation, sonoma:        "17bfc6d443b17cb1d7056704139c4fd7a026d194f095115ae9988917981dca18"
    sha256 cellar: :any_skip_relocation, ventura:       "2c2b200597f74af5963e7a9d383e4a9052c45850e9b5433c0dbce775460774ee"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "14ff87446ae39dea37b93a04dec35c452ef51c7a4d87e9a1b7f5306126c77374"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dda32b8743cdb0d0c2d88acc01adef28f2d7a911c18b80b1705505f798ab2693"
  end

  uses_from_macos "python" => [:build, :test], since: :catalina

  def install
    system "python3", "configure.py", "--bootstrap", "--verbose", "--with-python=python3"

    bin.install "ninja"
    bash_completion.install "miscbash-completion" => "ninja"
    zsh_completion.install "misczsh-completion" => "_ninja"
    doc.install "docmanual.asciidoc"
    (share"vimvimfilessyntax").install "miscninja.vim"
  end

  test do
    (testpath"build.ninja").write <<~NINJA
      cflags = -Wall

      rule cc
        command = gcc $cflags -c $in -o $out

      build foo.o: cc foo.c
    NINJA
    system bin"ninja", "-t", "targets"
    port = free_port
    fork do
      exec bin"ninja", "-t", "browse", "--port=#{port}", "--hostname=127.0.0.1", "--no-browser", "foo.o"
    end
    sleep 15
    assert_match "foo.c", shell_output("curl -s http:127.0.0.1:#{port}?foo.o")
  end
end