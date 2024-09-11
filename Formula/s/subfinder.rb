class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https:github.comprojectdiscoverysubfinder"
  url "https:github.comprojectdiscoverysubfinderarchiverefstagsv2.6.6.tar.gz"
  sha256 "636bccb8b5a18b709f735f29979e53752f3d71e1c246b7ce845d802766937bf2"
  license "MIT"
  head "https:github.comprojectdiscoverysubfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "aa46dddfe62e7e55267898f9ad74962c22f55e8519ef394f3417f6c8baba20a5"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "efaf677e10be0712b55d5ecaa52d051d28a86042d8a3acd1461422604d32f43c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd5648f025089584199f224c175687e4df53cfa1277ce0739de7ca4709c37344"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c6357c4aa97ac5bc6c653fb3677c44af1b7420ff6249173220abb57db29b2c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "61cfaf4f2557aea241ab54cf3a084d8a672def4e6fbc8e6571742747c0705a4a"
    sha256 cellar: :any_skip_relocation, ventura:        "d2f308d9d78009e06dd4329dc68acb2ffd8a4e0ec34328a3e882e50a1354c12b"
    sha256 cellar: :any_skip_relocation, monterey:       "807fdb2b92e0e61aa94698c09c35113b79972d73111521effa4f4633597e1e7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b6c890b75d2c4ad273867b4fb1206cfe620a49c0c666f1b491adf92e4a03243b"
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdsubfinder"
    end
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}subfinder -d brew.sh")

    # upstream issue, https:github.comprojectdiscoverysubfinderissues1124
    if OS.mac?
      assert_predicate testpath"LibraryApplication Supportsubfinderconfig.yaml", :exist?
      assert_predicate testpath"LibraryApplication Supportsubfinderprovider-config.yaml", :exist?
    else
      assert_predicate testpath".configsubfinderconfig.yaml", :exist?
      assert_predicate testpath".configsubfinderprovider-config.yaml", :exist?
    end

    assert_match version.to_s, shell_output("#{bin}subfinder -version 2>&1")
  end
end