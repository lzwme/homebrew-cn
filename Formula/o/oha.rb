class Oha < Formula
  desc "HTTP load generator, inspired by rakyllhey with tui animation"
  homepage "https:github.comhatoooha"
  url "https:github.comhatooohaarchiverefstagsv1.1.0.tar.gz"
  sha256 "3cc7a0c912a582bf7a3f6a9de8b61a04ee30c180f1a764fcb40c3b2ad9029024"
  license "MIT"
  head "https:github.comhatoooha.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fa2aaa82ab311f5721898f5f0f730d7b01d89dffe640bd647250da80e706a844"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cac7968fc1303bb416c8c75153db7ba1ef998e959504d9fcac86e3ed7730a492"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cec9c5fc90865918664e75c3cc5372f9df6413e1b2f069a603c865e03af867a1"
    sha256 cellar: :any_skip_relocation, sonoma:         "23e41238478fcd295749279e641da410adcd2c76267463deff018b9b8d2dd04e"
    sha256 cellar: :any_skip_relocation, ventura:        "d1a5d443a44e92b2cb734a144329ddf597f2ce015a2fa0e6093df9101da14f1a"
    sha256 cellar: :any_skip_relocation, monterey:       "7eb6f2c82dcdfd130e52e064d267b473300af48cbe6fc1776675f915e28b10dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5fc54ae74b8faf7cc7866b89fa317df85aeed24abf4aaa2214933836ef8432c"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "openssl@3" # Uses Secure Transport on macOS
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = "[200] 1 responses"
    assert_match output.to_s, shell_output("#{bin}oha -n 1 -c 1 --no-tui https:www.google.com")

    assert_match version.to_s, shell_output("#{bin}oha --version")
  end
end