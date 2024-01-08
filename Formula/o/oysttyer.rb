class Oysttyer < Formula
  desc "Command-line Twitter client"
  homepage "https:github.comoysttyeroysttyer"
  url "https:github.comoysttyeroysttyerarchiverefstags2.10.0.tar.gz"
  sha256 "3c0ce1c7b112f2db496cc75a6e76c67f1cad956f9e7812819c6ae7a979b2baea"
  head "https:github.comoysttyeroysttyer.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a1700139674a1c4bdfb17dc7b5c7d513f835ac100fd419ac07672cdd6f78ec1b"
  end

  deprecate! date: "2024-01-06", because: :repo_archived

  def install
    bin.install "oysttyer.pl" => "oysttyer"
  end

  test do
    IO.popen("#{bin}oysttyer", "r+") do |pipe|
      assert_equal "-- using SSL for default URLs.", pipe.gets.chomp
      pipe.puts "^C"
      pipe.close_write
    end
  end
end