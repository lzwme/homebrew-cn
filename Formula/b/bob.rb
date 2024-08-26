class Bob < Formula
  desc "Version manager for neovim"
  homepage "https:github.comMordechaiHadadbob"
  url "https:github.comMordechaiHadadbobarchiverefstagsv4.0.1.tar.gz"
  sha256 "684f7f02a779d0233c3a4f1b51513cbb9552e39e84c94d80762684b245777295"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "c91231c2090232187cb61c1360edf4b800e96414192b9303ce6398b122c7c87c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccdec4aff6fe1f5722953045434a965dc46964735eb2e073ca7190b402bada91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "744336c16ff489bb345537405373109071897d396acf9bc63fdfa4b630939127"
    sha256 cellar: :any_skip_relocation, sonoma:         "da2d427c087265532d83201195f969e7981f4326618286aff562a5614072f6d1"
    sha256 cellar: :any_skip_relocation, ventura:        "33544d9449fee94048e061faddfc59d0589b73dd098b8f6824c7d6c11b2168ac"
    sha256 cellar: :any_skip_relocation, monterey:       "180e16c53bbc51abedc35cfc382aed57523ef9af04a4346ad27fffa2a2792406"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0aa9af6eb10673cb55bce2546473a49c6c8421cd925db63f6b84ee2ee9828dba"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin"bob", "complete")
  end

  test do
    config_file = testpath"config.json"
    config_file.write <<~EOS
      {
        "downloads_location": "#{testpath}.localsharebob",
        "installation_location": "#{testpath}.localsharebobnvim-bin"
      }
    EOS
    ENV["BOB_CONFIG"] = config_file
    mkdir_p "#{testpath}.localsharebob"
    mkdir_p "#{testpath}.localsharenvim-bin"

    system bin"bob", "install", "v0.9.0"
    assert_match "v0.9.0", shell_output("#{bin}bob list")
    assert_predicate testpath".localsharebobv0.9.0", :exist?
    system bin"bob", "erase"
  end
end