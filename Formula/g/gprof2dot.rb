class Gprof2dot < Formula
  include Language::Python::Virtualenv

  desc "Convert the output from many profilers into a Graphviz dot graph"
  homepage "https:github.comjrfonsecagprof2dot"
  url "https:files.pythonhosted.orgpackages321116fc5b985741378812223f2c6213b0a95cda333b797def622ac702d28e81gprof2dot-2024.6.6.tar.gz"
  sha256 "fa1420c60025a9eb7734f65225b4da02a10fc6dd741b37fa129bc6b41951e5ab"
  license "LGPL-3.0-or-later"
  head "https:github.comjrfonsecagprof2dot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "3c844e39ef4287548064b0a50495b69e932bb8da99e1433885fffbf53f9b6e19"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a0e000bb5783e8ebe2ae2ed71435424043ccc58a7100b11778e9fe9dfc33f556"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a0e000bb5783e8ebe2ae2ed71435424043ccc58a7100b11778e9fe9dfc33f556"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a0e000bb5783e8ebe2ae2ed71435424043ccc58a7100b11778e9fe9dfc33f556"
    sha256 cellar: :any_skip_relocation, sonoma:         "a0e000bb5783e8ebe2ae2ed71435424043ccc58a7100b11778e9fe9dfc33f556"
    sha256 cellar: :any_skip_relocation, ventura:        "a0e000bb5783e8ebe2ae2ed71435424043ccc58a7100b11778e9fe9dfc33f556"
    sha256 cellar: :any_skip_relocation, monterey:       "a0e000bb5783e8ebe2ae2ed71435424043ccc58a7100b11778e9fe9dfc33f556"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "193194c610bdace3071a0923b19dc61d64d27442dcf085d404ebbc17e95cbde1"
  end

  depends_on "graphviz"
  depends_on "python@3.12"

  on_linux do
    depends_on "libx11"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath"gprof.output").write <<~EOS
      Flat profile:

      Each sample counts as 0.01 seconds.
       no time accumulated

        %   cumulative   self              self     total
       time   seconds   seconds    calls  Tscall  Tscall  name
        0.00      0.00     0.00        2     0.00     0.00  manager
        0.00      0.00     0.00        2     0.00     0.00  worker1
        0.00      0.00     0.00        2     0.00     0.00  worker2
        0.00      0.00     0.00        1     0.00     0.00  project1
        0.00      0.00     0.00        1     0.00     0.00  project2

       %         the percentage of the total running time of the
      time       program used by this function.

      cumulative a running sum of the number of seconds accounted
       seconds   for by this function and those listed above it.

       self      the number of seconds accounted for by this
      seconds    function alone.  This is the major sort for this
                 listing.

      calls      the number of times this function was invoked, if
                 this function is profiled, else blank.

       self      the average number of milliseconds spent in this
      mscall    function per call, if this function is profiled,
             else blank.

       total     the average number of milliseconds spent in this
      mscall    function and its descendents per call, if this
             function is profiled, else blank.

      name       the name of the function.  This is the minor sort
                 for this listing. The index shows the location of
             the function in the gprof listing. If the index is
             in parenthesis it shows where it would appear in
             the gprof listing if it were to be printed.
      
                   Call graph (explanation follows)


      granularity: each sample hit covers 2 byte(s) no time propagated

      index % time    self  children    called     name
                      0.00    0.00       12           project1 [4]
                      0.00    0.00       12           project2 [5]
      [1]      0.0    0.00    0.00       2         manager [1]
                      0.00    0.00       22           worker1 [2]
                      0.00    0.00       22           worker2 [3]
      -----------------------------------------------
                      0.00    0.00       22           manager [1]
      [2]      0.0    0.00    0.00       2         worker1 [2]
      -----------------------------------------------
                      0.00    0.00       22           manager [1]
      [3]      0.0    0.00    0.00       2         worker2 [3]
      -----------------------------------------------
                      0.00    0.00       11           main [12]
      [4]      0.0    0.00    0.00       1         project1 [4]
                      0.00    0.00       12           manager [1]
      -----------------------------------------------
                      0.00    0.00       11           main [12]
      [5]      0.0    0.00    0.00       1         project2 [5]
                      0.00    0.00       12           manager [1]
      -----------------------------------------------

       This table describes the call tree of the program, and was sorted by
       the total amount of time spent in each function and its children.

       Each entry in this table consists of several lines.  The line with the
       index number at the left hand margin lists the current function.
       The lines above it list the functions that called this function,
       and the lines below it list the functions this one called.
       This line lists:
           index    A unique number given to each element of the table.
              Index numbers are sorted numerically.
              The index number is printed next to every function name so
              it is easier to look up where the function in the table.

           % time    This is the percentage of the `total' time that was spent
              in this function and its children.  Note that due to
              different viewpoints, functions excluded by options, etc,
              these numbers will NOT add up to 100%.

           self    This is the total amount of time spent in this function.

           children    This is the total amount of time propagated into this
              function by its children.

           called    This is the number of times the function was called.
              If the function called itself recursively, the number
              only includes non-recursive calls, and is followed by
              a `+' and the number of recursive calls.

           name    The name of the current function.  The index number is
              printed after it.  If the function is a member of a
              cycle, the cycle number is printed between the
              function's name and the index number.


       For the function's parents, the fields have the following meanings:

           self    This is the amount of time that was propagated directly
              from the function into this parent.

           children    This is the amount of time that was propagated from
              the function's children into this parent.

           called    This is the number of times this parent called the
              function `' the total number of times the function
              was called.  Recursive calls to the function are not
              included in the number after the `'.

           name    This is the name of the parent.  The parent's index
              number is printed after it.  If the parent is a
              member of a cycle, the cycle number is printed between
              the name and the index number.

       If the parents of the function cannot be determined, the word
       `<spontaneous>' is printed in the `name' field, and all the other
       fields are blank.

       For the function's children, the fields have the following meanings:

           self    This is the amount of time that was propagated directly
              from the child into the function.

           children    This is the amount of time that was propagated from the
              child's children to the function.

           called    This is the number of times the function called
              this child `' the total number of times the child
              was called.  Recursive calls by the child are not
              listed in the number after the `'.

           name    This is the name of the child.  The child's index
              number is printed after it.  If the child is a
              member of a cycle, the cycle number is printed
              between the name and the index number.

       If there are any cycles (circles) in the call graph, there is an
       entry for the cycle-as-a-whole.  This entry shows who called the
       cycle (as parents) and the members of the cycle (as children.)
       The `+' recursive calls entry shows the number of function calls that
       were internal to the cycle, and the calls entry for each member shows,
       for that member, how many times it was called from other members of
       the cycle.

      
      Index by function name

         [1] manager                 [5] project2                [3] worker2
         [4] project1                [2] worker1
    EOS
    system bin"gprof2dot", testpath"gprof.output", "-o", testpath"call_graph.dot"
    assert_predicate testpath"call_graph.dot", :exist?
  end
end