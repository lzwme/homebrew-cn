class Cariddi < Formula
  desc "Scan for endpoints, secrets, API keys, file extensions, tokens and more"
  homepage "https:github.comedoardotttcariddi"
  url "https:github.comedoardotttcariddiarchiverefstagsv1.3.3.tar.gz"
  sha256 "47927abf07b5b643db9b0f0261867eb9e42e27f6370e11083131d61569b26042"
  license "GPL-3.0-or-later"
  head "https:github.comedoardotttcariddi.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "4714f33e2262e3db5a9549cfb3fbab286c4e48b93c4717ebb4c6b83e66bea9c6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39d8796c417ac9eeba79f69ebfd14a160d05105924f57dea61ca4bc36e341c4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b2d5cb8528aee72f903c4488faa8874b67f4f8e6d40a060db7775795f78eacd"
    sha256 cellar: :any_skip_relocation, sonoma:         "24e35cbe3f72560b0b17a16d645fd5f10d22053413893e0b4bf3bff755fef5b4"
    sha256 cellar: :any_skip_relocation, ventura:        "4d372ab6031996e11fb80b3a9dd184c7a70c9b4f8391af59002ae2b636d74df0"
    sha256 cellar: :any_skip_relocation, monterey:       "324dd9d626f292605ef363396a2799dea25f7438e68f9461761cace3b536148a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6496afa064293193cb4c876f739d35db1d26a4928182ff9973985cca7b27d28"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), ".cmdcariddi"
  end

  test do
    output = pipe_output("#{bin}cariddi", "http:testphp.vulnweb.com")
    assert_match "http:testphp.vulnweb.comlogin.php", output

    assert_match version.to_s, shell_output("#{bin}cariddi -version 2>&1")
  end
end