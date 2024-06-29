class Nuget < Formula
  desc "Package manager for Microsoft development platform including .NET"
  homepage "https://www.nuget.org/"
  url "https://dist.nuget.org/win-x86-commandline/v6.10.1/nuget.exe"
  sha256 "e41e724f541c1f0425e9e92856d19a0e87a8eb4cb692cada6e0399feb4b2b026"
  license "MIT"

  livecheck do
    url "https://dist.nuget.org/tools.json"
    regex(%r{"url":\s*?"[^"]+/v?(\d+(?:\.\d+)+)/nuget\.exe",\s*?"stage":\s*?"ReleasedAndBlessed"}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "120db5b989a88f244624281c3602c263d738e36a1be307cf188db7ca54c75968"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "120db5b989a88f244624281c3602c263d738e36a1be307cf188db7ca54c75968"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "120db5b989a88f244624281c3602c263d738e36a1be307cf188db7ca54c75968"
    sha256 cellar: :any_skip_relocation, sonoma:         "120db5b989a88f244624281c3602c263d738e36a1be307cf188db7ca54c75968"
    sha256 cellar: :any_skip_relocation, ventura:        "120db5b989a88f244624281c3602c263d738e36a1be307cf188db7ca54c75968"
    sha256 cellar: :any_skip_relocation, monterey:       "120db5b989a88f244624281c3602c263d738e36a1be307cf188db7ca54c75968"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ef9f9f706d2fa844a5576898058ab9c2b23fa8b67f209dad4e7d07204bf9e32"
  end

  depends_on "mono"

  def install
    libexec.install "nuget.exe" => "nuget.exe"
    (bin/"nuget").write <<~EOS
      #!/bin/bash
      mono #{libexec}/nuget.exe "$@"
    EOS
  end

  test do
    assert_match "NuGet.Protocol.Core.v3", shell_output("#{bin}/nuget list packageid:NuGet.Protocol.Core.v3")
  end
end