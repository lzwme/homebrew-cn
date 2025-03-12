class Monolith < Formula
  desc "CLI tool for saving complete web pages as a single HTML file"
  homepage "https:github.comY2Zmonolith"
  url "https:github.comY2Zmonolitharchiverefstagsv2.9.0.tar.gz"
  sha256 "c923af01abfde33328d48418af49d4a80143ad1070838f2b9d2a197bb1d66724"
  license "CC0-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67c39bcacb8fd40a440306cdc847647657ce9c102ef8d1b03f3cf4f0ce700c47"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "6bea0dd0d37054a3d1f9f38d5bdc1094834b79f9644697148fa9923098549600"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "a19396e38ff6e34154216c315248c0e994f24dcd609c5250c3a29cdec943491a"
    sha256 cellar: :any_skip_relocation, sonoma:        "248fb18abf3f9d06bc9512d25a46f2feb21c9e98a904b1e196bfa29ba8475254"
    sha256 cellar: :any_skip_relocation, ventura:       "ff63b53277eb79f24154500f1da05c8fb282bd0634c6668df3d950de70409844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99296d1923a60c554940dd73274257fd00041d0d6f17772b5e908228c65fcad4"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin"monolith", "https:lyrics.github.iodbPPortisheadDummyRoads"
  end
end