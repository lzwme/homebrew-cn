class Overarch < Formula
  desc "Data driven description of software architecture"
  homepage "https:github.comsoulspace-orgoverarch"
  url "https:github.comsoulspace-orgoverarchreleasesdownloadv0.14.0overarch.jar"
  sha256 "7d573e0c044e63487cf9104142651e79beb849282916cf63dcb3a3256211bff0"
  license "EPL-1.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bb81050adefd759c706a092a42444d4641b6117b9518d026dfe4b0e3545b1fb0"
  end

  head do
    url "https:github.comsoulspace-orgoverarch.git", branch: "main"
    depends_on "leiningen" => :build
  end

  depends_on "openjdk"

  def install
    if build.head?
      system "lein", "uberjar"
      jar = "targetoverarch.jar"
    else
      jar = "overarch.jar"
    end

    libexec.install jar
    bin.write_jar_script libexec"overarch.jar", "overarch"
  end

  test do
    (testpath"test.edn").write <<~EOS
      \#{
        {:el :person
         :id :test-customer}
        {:el :system
         :id :test-system}
        {:el :rel
         :id :customer-uses-system
         :from :test-customer
         :to :test-system}
        {:el :context-view
         :id :test-context-view
         :ct [
              {:ref :test-customer}
              {:ref :test-system}
              {:ref :customer-uses-system}]}
        {:el :container-view
         :id :test-container-view
         :ct [
              {:ref :test-customer}
              {:ref :test-system}
              {:ref :customer-uses-system}]}}
    EOS
    expected = <<~EOS.chomp
      Model Warnings:
      {:unresolved-refs-in-views (), :unresolved-refs-in-relations ()}
      Model Information:
      {:nodes {:person 1, :system 1},
       :relations {:rel 1},
       :views {:container-view 1, :context-view 1}}
    EOS
    assert_equal expected, shell_output("#{bin}overarch --model-dir=#{testpath} --model-info").chomp
  end
end