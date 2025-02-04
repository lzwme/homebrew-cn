class Bob < Formula
  desc "Version manager for neovim"
  homepage "https:github.comMordechaiHadadbob"
  url "https:github.comMordechaiHadadbobarchiverefstagsv4.0.3.tar.gz"
  sha256 "cb0b084ca0454fc17c387d9662b420764b2aa1152dfe035238b1d08bb7ab34f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "197aedb1360b5288d62570a28d4ab2799db3b23c5a66b7825d70b006a4eab70c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "abb9e82fa156473bf7477165601ce06461d34131dcedd97456341b8f24bec3e8"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "59d937fb5ca0b8f8e360a4685be621be76f843583bcb1711b3cf6b79007b1b6f"
    sha256 cellar: :any_skip_relocation, sonoma:        "37a0ae66998c2dcec0a690d1a3c56e2ee3c5ec6ebe4345a28a43858e80910d25"
    sha256 cellar: :any_skip_relocation, ventura:       "ec91b851216fb3b9489a1f58279f4290662bb7cb6ba2b74c49305b9ab61ba1ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "771d6922ebbff58d6c998d5c5217816d8f439a9c8462a4ce32886e7c183d0cce"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin"bob", "complete")
  end

  test do
    config_file = testpath"config.json"
    config_file.write <<~JSON
      {
        "downloads_location": "#{testpath}.localsharebob",
        "installation_location": "#{testpath}.localsharebobnvim-bin"
      }
    JSON

    ENV["BOB_CONFIG"] = config_file
    mkdir_p "#{testpath}.localsharebob"
    mkdir_p "#{testpath}.localsharenvim-bin"

    system bin"bob", "install", "v0.9.0"
    assert_match "v0.9.0", shell_output("#{bin}bob list")
    assert_predicate testpath".localsharebobv0.9.0", :exist?
    system bin"bob", "erase"
  end
end