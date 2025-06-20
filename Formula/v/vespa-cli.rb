class VespaCli < Formula
  desc "Command-line tool for Vespa.ai"
  homepage "https:vespa.ai"
  url "https:github.comvespa-enginevespaarchiverefstagsv8.536.21.tar.gz"
  sha256 "c7402f9dade42cf63d236c28e491e56cc8264aec9118c39f3645bd8f962d10dd"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(\D*?(\d+(?:\.\d+)+)(?:-\d+)?i)
    strategy :github_latest
  end

  no_autobump! because: :bumped_by_upstream

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e48e026806f88123d7fa86c834a05ab9f19a31df11ef08aee25ee8f0ba80e3ef"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c40433bc330913614a1a826e2e759a1176705baa68205c5e4709a1ce2dbe486d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4af6eb5edd7abfebe85739455a7e73f536a8502b530e55fce6669536319f383e"
    sha256 cellar: :any_skip_relocation, sonoma:        "29ab7540f02779ecefb2c8120e10fcbd8273a4eab48b8d15873838293f9c03d8"
    sha256 cellar: :any_skip_relocation, ventura:       "208f68b6a6a67545b68eca404594212b571c33d837d29128e3a92cdac3917ae6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1810c07a3a6f9c8c8f5c853703b1442bcdbe94c09e4acf0973bc8a8727a9c938"
  end

  depends_on "go" => :build

  def install
    cd "clientgo" do
      with_env(VERSION: version.to_s, PREFIX: prefix.to_s) do
        system "make", "install", "manpages"
      end
      generate_completions_from_executable(bin"vespa", "completion")
    end
  end

  test do
    ENV["VESPA_CLI_HOME"] = testpath
    assert_match "Vespa CLI version #{version}", shell_output("#{bin}vespa version")
    doc_id = "id:mynamespace:music::a-head-full-of-dreams"
    output = shell_output("#{bin}vespa document get #{doc_id} 2>&1", 1)
    assert_match "Error: deployment not converged", output
    system bin"vespa", "config", "set", "target", "cloud"
    assert_match "target = cloud", shell_output("#{bin}vespa config get target")
  end
end