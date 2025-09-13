class GitRemoteGcrypt < Formula
  desc "GPG-encrypted git remotes"
  homepage "https://spwhitton.name/tech/code/git-remote-gcrypt/"
  url "https://ghfast.top/https://github.com/spwhitton/git-remote-gcrypt/archive/refs/tags/1.5.tar.gz"
  sha256 "0a0b8359eccdd5d63eaa3b06b7a24aea813d7f1e8bf99536bdd60bc7f18dca03"
  license any_of: ["GPL-3.0-only", "GPL-2.0-or-later"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "4efe32b0ed3c56c7b8124db517898b05ac38ab6730e19c051ca05a5ec50c42ee"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0b60bf238fc835d16a3722c2169c060f08f3eab5182af7d3b67686d48a851391"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "f7d518f6a84f6a88cd98739da37b80af97c109f5a6694052d1036c6ae9f23821"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2ca9c6f99e37388e7e15b20f2980ad368dfa11e56d8724a92c360d142f81a44a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45fa5421d67d07106e203704401040e36360a7acf4a39fec0dc2b718cd155369"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8971a06391adac21a91d07b4d872808021f88a4b7e6f823104e91878afd1344"
    sha256 cellar: :any_skip_relocation, sonoma:         "511243a692e328688b88ba4091b5da01cb6511e0906aeb1fd2327142b703c38f"
    sha256 cellar: :any_skip_relocation, ventura:        "80d8af3e55e306c6711a445e6ff12d1117d9f38b9039b49e7a81aef8f84669ef"
    sha256 cellar: :any_skip_relocation, monterey:       "5394123d4778bf473b07c584a3d2d1a7348f466c73130829e592760237a54667"
    sha256 cellar: :any_skip_relocation, big_sur:        "484b02151ca66f3100841caf4717670ae3c080164daacb1db151a8c40f52ae3e"
    sha256 cellar: :any_skip_relocation, catalina:       "458f095f06a37bbea5d7487b5b819f774d883684c99bfca6636bc03e3c64def1"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "aab3674f42bd12e3a700bbd7b15ba442e480341e0c84fd7987c78f186d34cd16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57c8b96cc637d89a829bde8952c93946deee5c641c6cf07f1bcc484a5e4d5ece"
  end

  depends_on "docutils" => :build

  def install
    ENV["prefix"] = prefix
    system "./install.sh"
  end

  test do
    assert_match("fetch\npush\n", pipe_output(bin/"git-remote-gcrypt", "capabilities\n", 0))
  end
end