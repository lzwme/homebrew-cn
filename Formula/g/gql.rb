class Gql < Formula
  desc "Git Query language is a SQL like language to perform queries on .git files"
  homepage "https:github.comAmrDeveloperGQL"
  url "https:github.comAmrDeveloperGQLarchiverefstags0.32.0.tar.gz"
  sha256 "472676754f7dddb5b1f04f2ebc065877adec865b51bc52ea25e789c8cbdb6bd3"
  license "MIT"
  head "https:github.comAmrDeveloperGQL.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8685a3f5a8108de67db3e584c82617a2031f0e30a2432a0ccc5107716628b57b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cd67204e5f25d159e2f5b0a8ec99552bce091d8b7d088ed4a23d6dddc166d5b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "3f24349284f2a75658a36582b344de74c93f4e378281f3a56d703bdc74207fae"
    sha256 cellar: :any_skip_relocation, sonoma:        "f675c102029604cc07def64ad225c241951e6640de20029029f7956a92f625e7"
    sha256 cellar: :any_skip_relocation, ventura:       "d4cee8d130eec864e1341533084d2e7c4594a0ee7bda735a986e96f715e7d1bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4072f384dc41df0440bdab9c40077b7db822aa7fc2de179d22825a93784b0895"
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
    assert_equal "2", output.first["column_0"]
  end
end