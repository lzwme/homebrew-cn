class Vfox < Formula
  desc "Version manager with support for Java, Node.js, Flutter, .NET & more"
  homepage "https:vfox.lhan.me"
  url "https:github.comversion-foxvfoxarchiverefstagsv0.4.1.tar.gz"
  sha256 "f6336d795648ad8462771b19afd14221d91effc25f4837158f147936673c3c76"
  license "Apache-2.0"
  head "https:github.comversion-foxvfox.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "716e8929038c73dd218290b003f09c11c0bac9637622c77c75c98b97c5d9c991"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "52a4cb610ee54181c4eea0caf48cc2175fcafd9a50d0991280a61bb13228e823"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e533093fb183813661fe9de516a17f8e92720b3938d624607276780b7a0cc0ec"
    sha256 cellar: :any_skip_relocation, sonoma:         "75ea455327a8b6617674ad2ea856eb3962c7bafca62eb266839f3176c48f0ecc"
    sha256 cellar: :any_skip_relocation, ventura:        "de057f44e2bc1f893c73d768a7397e57444ba7c61badb591bed977825fe3f56b"
    sha256 cellar: :any_skip_relocation, monterey:       "c296a468a0dbab6e989f2d63160aa60040bfbcc0d13af5ae15621bcb163a5a70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41695089476415711b9b41fc19c18937113c9a87dfcd8e2a77b5b0322fa39925"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    bash_completion.install "completionsbash_autocomplete" => "vfox"
    zsh_completion.install "completionszsh_autocomplete" => "_vfox"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}vfox --version")

    system bin"vfox", "add", "golang"
    output = shell_output(bin"vfox info golang")
    assert_match "Golang plugin, https:go.devdl", output
  end
end