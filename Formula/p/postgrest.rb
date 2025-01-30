class Postgrest < Formula
  desc "Serves a fully RESTful API from any existing PostgreSQL database"
  homepage "https:github.comPostgRESTpostgrest"
  url "https:github.comPostgRESTpostgrestarchiverefstagsv12.2.6.tar.gz"
  sha256 "2cf3d3bce6bf20159117119bd0be7c5600f24cd7847608ba2b0003edab75ea39"
  license "MIT"
  head "https:github.comPostgRESTpostgrest.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6b6b7f2cb1f08c4fdef1373bd8062b2a897807aac6eb6063c8360f1f24d825a9"
    sha256 cellar: :any,                 arm64_sonoma:  "33dfa7743de8688bff33426ac51078e940b12fcad8e507e5ce8e82c311022326"
    sha256 cellar: :any,                 arm64_ventura: "6e5f6003d9cbbbd3caa1c0262f432b989a77b4b0b23ad94ce52dcbbe8560ee19"
    sha256 cellar: :any,                 sonoma:        "6a719eb1c71c7e9c4d2a6bfd33a87afb4e0f5873803614388da9268342480fd7"
    sha256 cellar: :any,                 ventura:       "c3c5e09fae8ea704f1cc33406ab09e4b4712af90154d73ecbf2b6d1298990b3e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "feaeba8d7d0981b37dc0a2dd82234feadc69be70d56d7e1d75fa4fc91f18e890"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc@9.8" => :build # GHC 9.10 blocked by deps, e.g. https:github.comprotoludeprotoludeissues149
  depends_on "libpq"

  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", "--ignore-project", *std_cabal_v2_args
  end

  test do
    output = shell_output("#{bin}postgrest --dump-config 2>&1")
    assert_match "db-anon-role", output
    assert_match "Failed to query database settings for the config parameters", output

    assert_match version.to_s, shell_output("#{bin}postgrest --version")
  end
end