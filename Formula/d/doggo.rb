class Doggo < Formula
  desc "Command-line DNS Client for Humans"
  homepage "https:doggo.mrkaran.dev"
  url "https:github.commr-karandoggoarchiverefstagsv1.0.0.tar.gz"
  sha256 "056c0edac0007293b519e6bd50ca9c3445cbe340e868c3d9030abc495b44c881"
  license "GPL-3.0-or-later"
  head "https:github.commr-karandoggo.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5e784cf587b3d2e618a5191412f9b20d965d78a2380fdcf46a7b7ab137482e2b"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a6e8c22ad35bf185fdc825652b307a0a67f6ec9e04e3f51a15e46782135675b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "feba172124f0d1ac79aebe226269b2eacd4db995e04a5559282d3f0e12755975"
    sha256 cellar: :any_skip_relocation, sonoma:         "40e876b120827cfbf372a1d92b94b7d729bea650a9de5daed374201900187fcc"
    sha256 cellar: :any_skip_relocation, ventura:        "b963b8356bc0fb582c65c2a36bee1b20d9c6be26b9861b5a59608c167db2fb77"
    sha256 cellar: :any_skip_relocation, monterey:       "a5fcf46d152bbfa5ce707d67356db082bf19d1d9ba5318fb22e26851674840b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef98956b824fe271ab76719b27f4a0f34c039c4ec390faa67ff5e8673d612625"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.buildVersion=#{version} -X main.buildDate=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), ".cmd"

    generate_completions_from_executable(bin"doggo", "completions")
  end

  test do
    answer = shell_output("#{bin}doggo --short example.com NS @1.1.1.1")
    assert_equal "a.iana-servers.net.\nb.iana-servers.net.\n", answer

    assert_match version.to_s, shell_output("#{bin}doggo --version")
  end
end