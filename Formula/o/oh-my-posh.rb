class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https:ohmyposh.dev"
  url "https:github.comJanDeDobbeleeroh-my-posharchiverefstagsv24.6.4.tar.gz"
  sha256 "dac5e27f9e9620a75742921ba5b27829f8344b357f9b461cacdb80b31181a022"
  license "MIT"
  head "https:github.comJanDeDobbeleeroh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "adb24cba341b8585cc9d5aaf1a57fe46bfe561c7466890ea6f62029b1c9e2154"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f035f013f06470d8da1458f3a7d32945e6ea3c1b89284225ee86c426751e145c"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "b3e7b147f8790cf7144938b92fac2da8ff3a049f63f4fe6461a547c4bf225406"
    sha256 cellar: :any_skip_relocation, sonoma:        "8582f9e318f96caec9fdb29b6ba17bee80923255c89db6da6a216b8dd84647e1"
    sha256 cellar: :any_skip_relocation, ventura:       "09d5fc64d1f724dbe65c6ab658a2b24a72e0b0a06005eb459adc07e14c5dd5c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "322f07666be009f6e3889ba2fad6a5f450a49a50eb1f4757a7f4940cd95f0123"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Version=#{version}
      -X github.comjandedobbeleeroh-my-poshsrcbuild.Date=#{time.iso8601}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags:)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix"themes"
  end

  test do
    assert_match "Oh My Posh", shell_output("#{bin}oh-my-posh init bash")
    assert_match version.to_s, shell_output("#{bin}oh-my-posh version")
  end
end