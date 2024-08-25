class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https:github.comAmrDeveloperGQL"
  url "https:github.comAmrDeveloperGQLarchiverefstags0.26.0.tar.gz"
  sha256 "a73c5640c6d3fdbb40d64cfad0aa10194321b0442d19300688bdc569b6def295"
  license "MIT"
  head "https:github.comAmrDeveloperGQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "1ec61e0759ce3be805fc7326d388a58299337fb7740c9b4e3c3ba1c09c4e3739"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4355551b8745a83c405b8b126e2a7c7222a64f910b757e4bc68f7429148542c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5e5ceb9391da6af6423dab0d8a1f61ecf893230bdc7c6ef01f4e1a3be872e7a"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cdafdef02efad3eb98bb7f6a4d2e853205ae9180f1fe61e59231b8e9eecac74"
    sha256 cellar: :any_skip_relocation, ventura:        "ce6d5c10b4a77265e6ae3dffd5fad588fefeb2b7fde5422557fa4c5388d11242"
    sha256 cellar: :any_skip_relocation, monterey:       "1131d0eecc6680fd9219dca5ef5d4bdaa6a8e16f480a9a773d9c8b92b21b56f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "779c5d4e0122f218201ea56a3f68b0e6b35d788e4ab173ffbca5e17392a09dda"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  conflicts_with "gitql", because: "both install `gitql` binaries"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system "git", "init"
    output = JSON.parse(shell_output("#{bin}gitql -o json -q 'SELECT 1 + 1 LIMIT 1'"))
    assert_equal "2", output.first["column_1"]
  end
end