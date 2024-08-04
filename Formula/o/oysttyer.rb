class Oysttyer < Formula
  desc "Command-line Twitter client"
  homepage "https:github.comoysttyeroysttyer"
  url "https:github.comoysttyeroysttyerarchiverefstags2.10.0.tar.gz"
  sha256 "3c0ce1c7b112f2db496cc75a6e76c67f1cad956f9e7812819c6ae7a979b2baea"
  head "https:github.comoysttyeroysttyer.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "634e4e86062e386843b2703b2a781b8de08a86539d39d7ffc9aa6db733b2c110"
  end

  deprecate! date: "2024-01-06", because: :repo_archived

  def install
    bin.install "oysttyer.pl" => "oysttyer"
  end

  test do
    IO.popen(bin"oysttyer", "r+") do |pipe|
      assert_equal "-- using SSL for default URLs.", pipe.gets.chomp
      pipe.puts "^C"
      pipe.close_write
    end
  end
end