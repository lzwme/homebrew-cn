class Bibtexconv < Formula
  desc "BibTeX file converter"
  homepage "https:github.comdreibhbibtexconv"
  url "https:github.comdreibhbibtexconvarchiverefstagsbibtexconv-1.4.2.tar.gz"
  sha256 "6e48f4c126ece596ee5fd086ad4e0c0d70b682b485cb5286f3b0c0fb8bd55d56"
  license "GPL-3.0-or-later"
  head "https:github.comdreibhbibtexconv.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4602cce4ed15087892deb6b08b5ddf744a7182d4a97931e05e64343132e6f99d"
    sha256 cellar: :any,                 arm64_sonoma:  "c1342b87e9c3bcdff21b49a6bddf914d63a6518f561012c359dab1d1e1c89a36"
    sha256 cellar: :any,                 arm64_ventura: "b1f68f2b2b7b02679ed98cdd755ba225301d605d4bcb672b6611701004501966"
    sha256 cellar: :any,                 sonoma:        "2e3764a846a146314b0c1da829e72bc7fd879a244857f4ebd68c6821c1dbad51"
    sha256 cellar: :any,                 ventura:       "7ba3f32a2ea7a1cb0280b3125c31e7af434b52df4d95c6670081e856a576f5ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecfbfd8288215525f44c3153f6dd2f3d6e03480a18653c0a9a73e7dde5f41798"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "openssl@3"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  def install
    system "cmake", *std_cmake_args,
                    "-DCRYPTO_LIBRARY=#{Formula["openssl@3"].opt_lib}#{shared_library("libcrypto")}"
    system "make", "install"
  end

  test do
    cp "#{opt_share}docbibtexconvexamplesExampleReferences.bib", testpath

    system bin"bibtexconv", "#{testpath}ExampleReferences.bib",
                             "-export-to-bibtex=UpdatedReferences.bib",
                             "-check-urls", "-only-check-new-urls",
                             "-non-interactive"
  end
end